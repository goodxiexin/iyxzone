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
        # mysql的设置是max_allowed_packet=16MB, id和名字最大也就80B, 理论上每次插入2000条记录肯定行
        with_step 2000, recipients.count do |offset|
          recipients[offset..(offset+2000)].each do |recipient|
            values << "(NULL, #{recipient.id}, '#{recipient.class.to_s}', #{item.id}, '#{self.class.name}', '#{Time.now.to_s(:db)}')"
          end
          sql = "insert into feed_deliveries values #{values.join(',')}"
          ActiveRecord::Base.connection.execute(sql)
        end
      end

      def destroy_feeds
        feed_items.each {|f| f.destroy}
      end

      def with_step step, total, &block
        i = 0
        while i * step < total
          yield (i * step)
          i = i + 1
        end
      end

    end
 
  end

end
