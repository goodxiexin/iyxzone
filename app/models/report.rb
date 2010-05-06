class Report < ActiveRecord::Base

  CATEGORY = ['内容色情', '内容反动', '其他']

  belongs_to :reportable, :polymorphic => true

  belongs_to :poster, :class_name => 'User' 

  validates_presence_of :content, :message => "不能为空"

  validates_size_of :content, :within => 1..10000, :too_long => "最长10000个字节", :too_short => "最短1个字节", :if => "content"

  validates_presence_of :reportable_id, :reportable_type, :message => "不能为空"

  validate_on_create :reportable_is_valid

  validates_inclusion_of :category, :in => CATEGORY, :message => "类型不对"

  after_create :set_verified_flag
  
protected

  def reportable_is_valid
    return if reportable_id.blank? or reportable_type.blank?
    reportable = reportable_type.camelize.constantize.find(:first, :conditions => {:id => reportable_id})
    if reportable.blank?
      errors.add(:reportable_id, "不存在")
    end
  end

  def set_verified_flag
    if reportable.verified != 2
      reportable.needs_verify
    end
  end

end
