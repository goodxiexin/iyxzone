class Sharing < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  named_scope :in, lambda {|type| type == 'all' ? {}:{:conditions => {:shareable_type => type}}} 

  belongs_to :poster, :class_name => 'User'

  belongs_to :share

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, sharing, comment| user == comment.poster || user == sharing.poster}

  acts_as_resource_feeds :recipients => lambda {|sharing| [sharing.poster.profile] + sharing.poster.guilds + sharing.poster.friends.find_all {|f| f.application_setting.recv_sharing_feed?} }

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
    
    if shareable.shared_by? poster
      errors.add(:share_id, '已经分享过了')
    elsif shareable.respond_to? :rejected? and shareable.rejected?
      errors.add(:share_id, '已经被和谐了，没法再分享')
    elsif !shareable.is_shareable_by? poster
      errors.add(:share_id, '没有权限分享')
    end
  end

end
