class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :shareable, :polymorphic => true

  named_scope :hot, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

  named_scope :recent, :conditions => ["created_at >?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"

  needs_verification 
 
  acts_as_commentable :order => 'created_at ASC', :recipient_required => false

  acts_as_resource_feeds

  acts_as_diggable

  attr_readonly :poster_id, :shareable_id, :shareable_type, :title, :reason

  validates_presence_of :poster_id, :message => "不能为空", :on => :create

  validates_presence_of :shareable_type, :message => "不能为空", :if => "link.blank?", :on => :create

  validates_presence_of :shareable_id, :message => "不能为空", :if => "link.blank?", :on => :create

  validate_on_create :shareable_is_valid

  validates_presence_of :title, :message => "不能为空", :on => :create

  validates_size_of :title, :within => 1..300, :too_long => "最长300个字节", :too_short => "最少一个字节", :if => "title", :on => :create

  validates_size_of :reason, :within => 0..1000, :too_long => "最长1000个字节", :if => "reason", :on => :create

  def link= link
    if link.blank?
      @link = ""
    elsif link.starts_with?("http://")
      @link = link
    else
      @link = "http://#{link}"
    end
  end

  def link
    @link
  end

  before_create :create_link

protected

  def create_link
    return if @link.blank?
    
    link = Link.new(:url => @link)
    if link.save
      self.shareable = link
    else
      errors.add(:link, "不是合法的url")
      return false
    end
  end

  def shareable_is_valid
    return if poster_id.blank?
    return if link.blank? and (shareable_id.blank? or shareable_type.blank?)

    if link.blank?
      shareable = shareable_type.camelize.constantize.find(shareable_id)
      if shareable.blank?
        errors.add(:shareable_id, '不存在')
      elsif shareable.shared_by? poster
        errors.add(:shareable_id, '已经分享过了')
      end
    else
      # 一个新的连接
      
    end 
  end

end
