class Message < ActiveRecord::Base

  belongs_to :recipient, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  acts_as_emotion_text :columns => [:content]

  validates_presence_of :recipient_id, :message => "不能为空"

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :content, :message => "不能为空"

  validates_size_of :content, :within => 1..150, :too_long => "最多150", :too_short => "最少1"

end
