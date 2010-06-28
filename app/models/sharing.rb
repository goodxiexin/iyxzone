class Sharing < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}, :order => 'created_at DESC'}}

  named_scope :in, lambda {|type| type.to_s == 'all' ? {} : {:conditions => {:shareable_type => type.to_s}}} 

  belongs_to :poster, :class_name => 'User'

  belongs_to :share

  acts_as_commentable :order => 'created_at ASC', :delete_conditions => lambda {|user, sharing, comment| user == comment.poster || user == sharing.poster}

  acts_as_resource_feeds :recipients => lambda {|sharing| 
    poster = sharing.poster
    friends = poster.friends.find_all {|f| f.application_setting.recv_sharing_feed?}
    [poster.profile] + poster.all_guilds + friends + (poster.is_idol ? poster.fans : [])
  }

  attr_protected :shareable_type

  validates_presence_of :poster_id

  validates_presence_of :share_id

  validate_on_create :sharing_is_valid

  validates_size_of :title, :within => 1..100

  validates_size_of :reason, :maximum => 10000, :allow_blank => true

  def shareable
    share.blank? ? nil : share.shareable
  end

protected

  def sharing_is_valid
    return if share.blank? or poster.blank?
    
    if shareable.shared_by? poster
      errors.add(:share_id, '已经分享过了')
    elsif !shareable.is_shareable_by? poster
      errors.add(:share_id, '没有权限分享')
    end
  end

end
