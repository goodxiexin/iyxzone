class PollAnswer < ActiveRecord::Base

  needs_verification :sensitive_columns => [:description]

  belongs_to :poll, :counter_cache => :answers_count

  attr_readonly :poll_id, :description

  validates_presence_of :poll_id, :message => "不能为空"

  validates_presence_of :description, :message => "不能为空"

  validates_size_of :description, :within => 1..1000, :too_long => "最多1000个字节", :too_short => "最少1个字节"

end
