class PokeDelivery < ActiveRecord::Base

	belongs_to :sender, :class_name => 'User'

	belongs_to :recipient, :class_name => 'User'

	belongs_to :poke

  attr_readonly :sender_id, :recipient_id, :poke_id

  validates_presence_of :sender_id

  validates_presence_of :recipient_id

  validates_presence_of :poke_id

  validate_on_create :poke_is_valid

  def self.delete_all_for user
    self.delete_all :recipient_id => user.id
    user.poke_deliveries_count = 0
    user.save
  end

protected

  def poke_is_valid
    errors.add(:poke_id, '不存在') if poke.nil?
  end

end
