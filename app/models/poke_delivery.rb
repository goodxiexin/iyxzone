class PokeDelivery < ActiveRecord::Base

	belongs_to :sender, :class_name => 'User'

	belongs_to :recipient, :class_name => 'User', :counter_cache => :poke_deliveries_count

	belongs_to :poke

  attr_readonly :sender_id, :recipient_id, :poke_id

  validates_presence_of :sender_id, :message => "不能为空"

  validates_presence_of :recipient_id, :message => "不能为空"

  validates_presence_of :poke_id, :message => "不能为空"

  validate_on_create :poke_is_valid

  #validate_on_create :recipient_is_valid

protected

  def poke_is_valid
    if poke.nil?
      errors.add(:poke_id, '不存在')
    end
  end

  def recipient_is_valid
    return if recipient.blank? or sender.blank?
    unless recipient.is_pokeable_by? sender
      errors.add(:recipient_id, "没有权限")
    end
  end

end
