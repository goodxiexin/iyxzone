class Skin < ActiveRecord::Base

  PUBLIC = 0
  PRIVATE = 1

  named_scope :for, lambda {|category| {:conditions => {:category => category}}}

  serialize :access_list, Array

  named_scope :for_all 
  def default?
    name == '默认'
  end

  def is_public?
    privilege == PUBLIC 
  end

  def accessible_for? skinnable
    (skinnable.class.name == self.category) and (is_public? or (!access_list.blank? and access_list.include?(skinnable.id)))
  end

  validates_uniqueness_of :name, :message => "已经存在了"

  validates_inclusion_of :privilege, :in => [PUBLIC, PRIVATE]

  validates_inclusion_of :category, :in => ['Profile']

end
