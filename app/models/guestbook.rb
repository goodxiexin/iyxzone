class Guestbook < ActiveRecord::Base

  ErrorElements = ['日志', '视频','照片','状态','活动','投票','工会','分享','游戏','推荐游戏','每日十闻','首页','个人主页','好友','站内信','通知','邀请','设置',    '其它']

  belongs_to :user

  validates_presence_of :user_id, :message => "不能为空"

  validates_presence_of :description, :message => "不能为空"

  validates_size_of :description, :within => 1..10000, :too_long => "最长10000个字符", :too_short => "最短1个字符", :if => "description"

  validates_size_of :reply, :within => 1..10000, :too_long => "最长10000个字符", :too_short => "最短1个字符", :if => "reply"

  validates_inclusion_of :priority, :in => [1, 2], :message => "只能是1或者2"

  validates_inclusion_of :catagory, :in => ErrorElements, :message => "类型不对" 

  attr_readonly :user_id, :catagory, :priority

  attr_protected :reply, :done_date

  attr_accessor :recently_reply_to_poster

  def reply_to_poster text
    self.recently_reply_to_poster = true
    self.reply = text
    self.save
  end

end
