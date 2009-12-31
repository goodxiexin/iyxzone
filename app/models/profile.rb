class Profile < ActiveRecord::Base

	MAX_VISITOR_RECORDS = 60 # 4 pages, 15 records per page??

  belongs_to :user

	belongs_to :region

	belongs_to :city

	belongs_to :district

  acts_as_viewable

	acts_as_commentable :order => 'created_at DESC'

	acts_as_taggable

	acts_as_resource_feeds

	has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

  # virtual attribute: login
  def login
    user.login
  end

  def login= new_login
    user.update_attribute('login', new_login)
  end

end

