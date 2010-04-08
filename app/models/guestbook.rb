class Guestbook < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user_id, :message => "不能为空"

  validates_presence_of :description, :message => "不能为空"

  validates_size_of :description, :within => 1..10000, :too_long => "最长10000个字符", :too_short => "最短1个字符", :if => "description"

  validates_size_of :reply, :within => 1..10000, :too_long => "最长10000个字符", :too_short => "最短1个字符", :if => "reply"

  validates_inclusion_of :priority, :in => [1, 2], :message => "只能是1或者2"

  validates_inclusion_of :category, :in => 

end
