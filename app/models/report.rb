class Report < ActiveRecord::Base

  CATEGORY = ['内容色情', '内容反动', '其他']

  belongs_to :reportable, :polymorphic => true

  belongs_to :poster, :class_name => 'User' 

  validates_size_of :content, :within => 1..10000, :allow_blank => true

  validate_on_create :reportable_is_valid

  validates_inclusion_of :category, :in => CATEGORY

  after_create :set_verified_flag
  
protected

  def reportable_is_valid
    if reportable.blank?
      errors.add(:reportable_id, "不存在")
    elsif reportable.rejected?
      errors.add(:reportable_id, "已经被和谐了")
    end
  end

  def set_verified_flag
    reportable.needs_verify
    reportable.save
  end

end
