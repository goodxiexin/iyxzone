class PokeDelivery < ActiveRecord::Base

	belongs_to :sender, :class_name => 'User'

	belongs_to :recipient, :class_name => 'User', :counter_cache => :poke_deliveries_count

	belongs_to :poke

  attr_readonly :sender_id, :recipient_id, :poke_id

  validates_presence_of :sender_id, :message => "不能为空"

  validates_presence_of :recipient_id, :message => "不能为空"

  validates_presence_of :poke_id, :message => "不能为空"

  validate_on_create :poke_exists

protected

  def poke_exists
    return if poke_id.nil?
    errors.add(:poke_id, "不存在") unless Poke.exists?(poke_id)
  end

end
