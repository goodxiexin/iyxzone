class MiniTopic < ActiveRecord::Base

  validates_presence_of :name

  validates_uniqueness_of :name  

  named_scope :hot, :order => "freq DESC"

end
