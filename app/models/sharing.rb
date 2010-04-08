class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :share

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, sharing, comment| user == comment.poster || user == sharing.poster}

  acts_as_resource_feeds

  attr_protected :shareable_type

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :share_id, :message => "不能为空"

  validate_on_create :sharing_is_valid

  validates_presence_of :title, :message => '不能为空'

  validates_size_of :title, :within => 1..100, :too_short => '最短1个字符', :too_long => '最长100个字符', :allow_nil => true

  validates_size_of :reason, :maximum => 10000, :too_long => '最长10000个字符', :allow_nil => true  

  def shareable
    share.blank? ? nil : share.shareable
  end

protected

  def sharing_is_valid
    return if share.blank? or poster.blank?
    if share.shareable.shared_by? poster
      errors.add(:share_id, '已经分享过了')
    end
  end

end
