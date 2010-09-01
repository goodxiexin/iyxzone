class Poll < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  related_to_game

  has_many :answers, :class_name => 'PollAnswer', :dependent => :delete_all

  has_many :votes

  has_many :voters, :through => :votes

	has_many :invitations, :class_name => 'PollInvitation', :order => 'created_at DESC'

  has_many :invitees, :through => :invitations, :source => 'user'

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  named_scope :hot, :conditions => ["created_at > ? AND ((no_deadline = 0 AND deadline > ?) OR no_deadline = 1)", 2.weeks.ago.to_s(:db), Time.now.to_s(:db)], :order => "voters_count DESC, created_at DESC"

  named_scope :recent, :conditions => ["created_at > ? AND ((no_deadline = 0 AND deadline > ?) OR no_deadline = 1)", 2.weeks.ago.to_s(:db), Date.today.to_s(:db)], :order => 'created_at DESC'

  needs_verification :sensitive_columns => [:description, :explanation, :name] 
 
  acts_as_diggable

	acts_as_commentable :order => 'created_at ASC', :delete_conditions => lambda {|user, poll, comment| poll.poster == user || comment.poster == user}

  acts_as_resource_feeds :recipients => lambda {|poll| 
    poster = poll.poster
    friends = poster.friends.all(:select => "users.id, users.application_setting").find_all {|f| f.application_setting.recv_poll_feed? }
    fans = poster.is_idol ? poster.fans.all(:select => "id") : []
    others = [poster.profile] + poll.games + poster.all_guilds
    (others + friends + fans).uniq
  }

  acts_as_random
  
  attr_readonly :poster_id, :no_deadline

  validates_presence_of :poster_id, :message => "不能为空", :on => :create

  validates_presence_of :name, :message => "不能为空"

  validates_size_of :name, :within => 1..100, :too_long => "最长100个字符", :too_short => "最短1个字符"

  validates_size_of :description, :within => 0..1000, :too_long => "最长1000个字符", :allow_blank => true

  validates_size_of :explanation, :within => 0..1000, :too_long => "最长1000个字符", :allow_blank => true

  validates_presence_of :deadline, :message => "不能为空", :if => "!no_deadline"

  validate_on_create :deadline_is_valid

  validate_on_create :answer_exists

  def expired?
    !self.no_deadline and self.deadline < Time.now.to_date
  end

  def is_votable_by? user
    user == poster || privilege == 1 || (privilege == 2 and poster.has_friend? user)
  end

  def voted_by? user
    voters.include? user
  end

  def has_invited? user
    !invitations.find_by_user_id(user.is_a?(Integer) ? user : user.id).blank?
  end

  def has_answers? answer_ids
    answers.all(:conditions => {:id => answer_ids}).count == answer_ids.count
  end

  def answers= answer_attributes
    @answer_attributes = answer_attributes.blank? ? nil : answer_attributes.find_all {|a| !a[:description].blank?}
  end

  after_save :save_answers

  def save_answers
    unless @answer_attributes.blank?
      @answer_attributes.each { |answer_attribute| answers.create(answer_attribute) }
      @answer_attributes = nil
    end
  end 

  def invite users
    return if users.blank?
    users.to_a.each do |user|
      invitations.build(:user_id => user.id)
    end
    save
  end

protected

  def deadline_is_valid 
    return if no_deadline or deadline.blank?
    errors.add(:deadline, "截止时间不能比现在早") if deadline <= Time.now.to_date
  end

  def answer_exists
    errors.add(:answers_count, "没有选项") if @answer_attributes.blank?
  end

end


