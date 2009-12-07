class Profile < ActiveRecord::Base

	MAX_VISITOR_RECORDS = 60 # 4 pages, 15 records per page??

  belongs_to :user

	belongs_to :region

	belongs_to :city

	belongs_to :district

	acts_as_commentable :order => 'created_at DESC'

	acts_as_taggable

	acts_as_resource_feeds

	has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

	has_many :visitor_records, :order => 'created_at DESC'

  def create_or_update_visitor_record user 
    record = visitor_records.find_by_visitor_id(user.id)
    if record.nil? # create a new one
      if visitor_records.count >= Profile::MAX_VISITOR_RECORDS
        visitor_records.last.destroy
      end
      visitor_records.create(:visitor_id => user.id)
    else # update old one
      record.update_attribute('created_at', Time.now)
    end
  end

end

