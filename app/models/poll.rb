class Poll < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User', :counter_cache => true

  belongs_to :game

  has_many :answers, :class_name => 'PollAnswer', :dependent => :destroy

  has_many :votes

  has_many :voters, :through => :votes

	has_many :invitations, :class_name => 'PollInvitation', :dependent => :destroy, :order => 'created_at DESC'

	acts_as_commentable :order => 'created_at ASC'

	named_scope :hot, :conditions => ["end_date > ?", Date.today.to_s(:db)], :order => "voters_count DESC"

	named_scope :recent, :conditions => ["end_date > ?", Date.today.to_s(:db)], :order => 'created_at DESC'

	acts_as_resource_feeds

  validate do |poll|
    poll.errors.add_to_base("名字不能为空") if poll.name.blank?
    poll.errors.add_to_base("名字不能超过100个字符") if poll.name.length > 100
    poll.errors.add_to_base("描述不能超过5000个字符") if poll.description and poll.description.length > 5000
    poll.errors.add_to_base("结束时间要比今天晚阿") if poll.end_date and poll.end_date <= Time.now.to_date 
    poll.errors.add_to_base("游戏类别不能为空") if poll.game_id.blank?
  end

  def past
    end_date < Time.now.to_date
  end

	def votable? user
		user == poster || privilege == 1 || (privilege == 2 and poster.has_friend? user)
	end

end
