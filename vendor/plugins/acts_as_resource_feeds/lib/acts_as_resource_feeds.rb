# ActsAsResourceFeeds
module ActsAsResourceFeeds

	def self.included base
		base.extend(ClassMethods)
	end	

	module ClassMethods
		
		def acts_as_resource_feeds

			has_many :feed_items, :as => 'originator', :dependent => :destroy

			define_method(:deliver_feeds) do |opts|
				return if opts[:recipients].blank?
				item = feed_items.create(:data => opts[:data])
				values = []
				# use self.class.name rather than item.originator_type ensures correct class name
				opts[:recipients].each do |recipient|
					values << "(NULL, #{recipient.id}, '#{recipient.class.to_s}', #{item.id}, '#{self.class.name}', '#{Time.now.to_s(:db)}')"
				end
				sql = "insert into feed_deliveries values #{values.join(',')}"
				ActiveRecord::Base.connection.execute(sql)	
			end	

      define_method(:destroy_feeds) do
        feed_items.each {|item| item.destroy}
      end

		end

	end

end
