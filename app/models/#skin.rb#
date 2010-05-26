class Skin < ActiveRecord::Base

	has_many :profiles

  has_many :vip_skins
  
  has_many :allowed_users, :through => :vip_skins, :source => :user

  acts_as_list :order => 'id'

  named_scope :for_all 
  def default?
    name == 'default'
  end
  
end
