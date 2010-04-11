class Album < ActiveRecord::Base

	belongs_to :poster, :class_name => 'User'

  belongs_to :game

  named_scope :recent, :conditions => "photos_count != 0 AND privilege != 4", :order => 'uploaded_at DESC'

  acts_as_privileged_resources :owner_field => :poster

  acts_as_shareable :default_title => lambda { |album| album.title }, :path_reg => [/\/personal_albums\/([\d]+)/, /\/event_albums\/([\d]+)/, /\/guild_albums\/([\d]+)/, /\/avatar_albums\/([\d]+)/]

  acts_as_resource_feeds

	def recent_photos limit
		photos.find(:all, :limit => limit)
	end

end
