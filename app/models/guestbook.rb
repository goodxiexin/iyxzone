class Guestbook < ActiveRecord::Base

  Urgent = 0
  Justsoso = 1

  ErrorElements = ['日志', '视频','照片','状态','活动','投票','工会','分享','游戏','推荐游戏','拾闻','首页','个人主页','好友','站内信','通知','邀请','设置',    '其它']

  belongs_to :user

  validate_on_create :user_or_email_exists

  validates_presence_of :description, :message => "不能为空"

  validates_size_of :description, :within => 1..1000, :too_long => "最长1000个字符", :too_short => "最短1个字符", :allow_blank => true

  validates_size_of :reply, :within => 1..1000, :too_long => "最长1000个字符", :too_short => "最短1个字符", :allow_blank => true

  validates_inclusion_of :priority, :in => [Urgent, Justsoso], :message => "只能是1或者2"

  validates_inclusion_of :catagory, :in => ErrorElements, :message => "类型不对" 

  # 不能让用户修改这2个域
  attr_protected :reply, :done_date

  def recently_set_reply?
    @action == :recently_set_reply
  end

  def set_reply text
    @action = :recently_set_reply
    self.reply = text
    self.save
  end

protected

  def user_or_email_exists
    if user_id.blank? and email.blank?
      errors.add(:user_id, 'email或者用户id不能为空')
    elsif !user_id.blank?
      errors.add(:user_id, '不存在') if user.blank?
    end
  end

end
