class Notification < ActiveRecord::Base

	belongs_to :user, :counter_cache => true

  named_scope :unread, :conditions => {:read => false}

end
