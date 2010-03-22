class Skin < ActiveRecord::Base

	has_many :profiles

  acts_as_list :order => 'id'

  def default?
    name == 'default'
  end
  
end
