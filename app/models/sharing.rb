class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :share

  def shareable
    share.nil? ? nil : share.shareable
  end

  acts_as_commentable

end

