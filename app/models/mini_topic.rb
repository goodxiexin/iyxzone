class MiniTopic < ActiveRecord::Base

  TopicReg = /#([^#.]+)#/

  validates_presence_of :name

  validates_uniqueness_of :name  

end
