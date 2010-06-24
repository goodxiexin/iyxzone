class Rating < ActiveRecord::Base
  
	named_scope :by, lambda {|user_ids| {:conditions => {:user_id => user_ids}}}
  
	belongs_to :rateable, :polymorphic => true
  
  belongs_to :user

	Default = 3
	Maximum = 5
	Minimum = 1

  attr_readonly :user_id, :rateable_id, :rateable_type

  validates_presence_of :user_id

  validate_on_create :rateable_is_valid

  validates_inclusion_of :rating, :in => Minimum..Maximum

protected

	def rateable_is_valid
		if rateable.blank?
      errors.add(:rateable, '不存在')
		elsif user and !rateable.is_rateable_by? user
      errors.add(:rateable, '没有打分的权力')
    end
	end

end
