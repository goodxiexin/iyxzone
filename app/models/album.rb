class Album < ActiveRecord::Base

  named_scope :prefetch, lambda {|opts| {:include => opts}}

	belongs_to :poster, :class_name => 'User'

  belongs_to :game

  named_scope :recent, :conditions => "photos_count != 0", :order => 'uploaded_at DESC'

  needs_verification :sensitive_columns => [:title, :description]

  acts_as_privileged_resources :owner_field => :poster

  acts_as_shareable :path_reg => [/\/personal_albums\/([\d]+)/, /\/event_albums\/([\d]+)/, /\/guild_albums\/([\d]+)/, /\/avatar_albums\/([\d]+)/],
                    :default_title => lambda {|album| album.title}, 
                    :create_conditions => lambda {|user, album| !album.is_owner_privilege?}

  acts_as_resource_feeds

end
