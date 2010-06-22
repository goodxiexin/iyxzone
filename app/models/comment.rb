class Comment < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  belongs_to :commentable, :polymorphic => true

  produce_notices :relative => lambda {|comment| [comment.commentable_id, comment.commentable_type]}

  needs_verification :sensitive_columns => [:content]

  # escape html before convert emotion image, otherwise emotion would also be escaped
  escape_html :sanitize => :content
  
  acts_as_emotion_text :columns => [:content]

  # 只能创建，不能修改，所有的属性不能修改
  attr_readonly :poster_id, :recipient_id, :commentable_id, :commentable_type, :content

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :content, :message => "不能为空"

  validates_size_of :content, :within => 1..140, :too_long => "最长140个字符", :too_short => "最短1个字符", :allow_blank => true

  validates_presence_of :commentable_id, :commentable_type, :message => "不能为空"

  validate_on_create :commentable_is_valid

  validates_presence_of :recipient_id, :message => "不能为空", :if => "commentable and is_recipient_required?"

  def is_deleteable_by? user
    commentable.is_comment_deleteable_by? user, self
  end

  def is_recipient_required?
    commentable.is_comment_recipient_required?
  end

protected

  def commentable_is_valid
    return if commentable_id.blank? or commentable_type.blank?
    
    if commentable.blank?
      errors.add(:commentable_id, "不存在")
    elsif !poster_id.blank? and !commentable.is_commentable_by? poster
      errors.add(:commentable_id, "没有权限")
    end
  end

end
