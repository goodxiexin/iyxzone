class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => "User"

  acts_as_commentable

end
