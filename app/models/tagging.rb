class Tagging < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

	belongs_to :taggable, :polymorphic => true

	belongs_to :tag

	belongs_to :poster, :class_name => 'User'

  attr_accessor :tag_name

  # 所有属性都只能在创建的时候赋值
  # tag_id不检查，由虚拟属性tag_name来赋值（可能会创建一个新的）
  attr_readonly :poster_id, :taggable_id, :taggable_type, :tag_id

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :taggable_id, :taggable_type, :message => "不能为空"

  validate_on_create :taggable_is_valid

  validates_presence_of :tag_name, :message => "不能为空", :on => :create

  validates_size_of :tag_name, :within => 1..100, :too_long => "最长100个字节", :too_short => "最短1个字节", :on => :create

protected

  def taggable_is_valid
    return if taggable_id.blank? or taggable_type.blank?
    
    if taggable.blank?
      errors.add(:taggable_id, "被标记的资源不存在")
    elsif poster and !taggable.is_taggable_by? poster
      errors.add(:taggable_id, "没有权限标记")
    end
  end

end
