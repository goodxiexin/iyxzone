class Message < ActiveRecord::Base

  belongs_to :recipient, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  # escape html before convert emotion image, otherwise emotion would also be escaped
  escape_html :sanitize => :content

  acts_as_emotion_text :columns => [:content]

  validates_presence_of :recipient_id

  validates_presence_of :poster_id

  validates_size_of :content, :within => 1..150

end
