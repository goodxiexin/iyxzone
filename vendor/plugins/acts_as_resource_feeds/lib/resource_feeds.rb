# /ActsAsResourceFeeds
module ResourceFeeds

	def self.included base
		base.extend(ClassMethods)
	end	

	module ClassMethods

    def acts_as_feed_recipient opts={}
    
      has_many :feed_deliveries, :as => 'recipient', :dependent => :delete_all, :order => 'created_at DESC'

      # alias for feed_deliveries
      has_many :all_feed_deliveries, :as => 'recipient', :class_name => 'FeedDelivery', :order => 'created_at DESC'

      cattr_accessor :feed_recipient_opts

      self.feed_recipient_opts = opts

      opts[:categories].each do |item_key, item_type|
        has_many "#{item_key}_feed_deliveries", :class_name => 'FeedDelivery', :as => 'recipient', :order => 'created_at DESC', :conditions => {:item_type => item_type}

        has_many "#{item_key}_feed_items", :through => "#{item_key}_feed_deliveries", :source => 'feed_item', :order => 'created_at DESC' 
      end unless opts[:categories].blank?

      include FeedRecipient::InstanceMethods

    end
		
		def acts_as_resource_feeds opts={}

			has_many :feed_items, :as => 'originator', :dependent => :destroy

      cattr_accessor :resource_feeds_opts

      self.resource_feeds_opts = opts

      include FeedProvider::InstanceMethods

		end

	end

  module FeedRecipient
    
    module InstanceMethods
  
      def is_feed_deleteable_by? user, feed_delivery
        proc = self.class.feed_recipient_opts[:delete_conditions] || lambda { false }
        proc.call user, self
      end

      def recv_feed? resource
        feed_deliveries.select {|f| f.feed_item.originator == resource}.count != 0
      end

    end

  end

  module FeedProvider
 
    module InstanceMethods

      def deliver_feeds opts={}
        if opts[:recipients].blank?
          recipients = (self.class.resource_feeds_opts[:recipients] || lambda {[]}).call self
        else
          recipients = opts[:recipients]
        end
        return if recipients.blank?
        item = feed_items.create(:data => opts[:data])
        values = []
        # use self.class.name rather than item.originator_type ensures correct class name
        recipients.each do |recipient|
          values << "(NULL, #{recipient.id}, '#{recipient.class.to_s}', #{item.id}, '#{self.class.name}', '#{Time.now.to_s(:db)}')"
        end
        sql = "insert into feed_deliveries values #{values.join(',')}"
        ActiveRecord::Base.connection.execute(sql)  
      end

      def destroy_feeds
        feed_items.each {|f| f.destroy}
      end

    end
 
  end

end
