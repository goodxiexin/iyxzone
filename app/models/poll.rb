class Poll < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  has_many :answers, :class_name => 'PollAnswer', :dependent => :destroy

  has_many :votes

  has_many :voters, :through => :votes

	has_many :invitations, :class_name => 'PollInvitation', :dependent => :destroy, :order => 'created_at DESC'

  named_scope :hot, :conditions => ["created_at > ? AND ((no_deadline = 0 AND deadline > ?) OR no_deadline = 1)", 2.weeks.ago.to_s(:db), Time.now.to_s(:db)], :order => "voters_count DESC"

  named_scope :recent, :conditions => ["created_at > ? AND ((no_deadline = 0 AND deadline > ?) OR no_deadline = 1)", 2.weeks.ago.to_s(:db), Date.today.to_s(:db)], :order => 'created_at DESC'

  acts_as_diggable

  acts_as_shareable
  
	acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, poll, comment| poll.poster == user || comment.poster == user}

  acts_as_resource_feeds

  def past
    !self.no_deadline and self.deadline < Time.now.to_date
  end

  def votable_by user
    user == poster || privilege == 1 || (privilege == 2 and poster.friends.include? user)
  end

  def answers=(answer_attributes)
    @answer_attributes = answer_attributes.find_all {|a| !a[:description].blank?}
  end

  after_save :save_answers

  def save_answers
    @answer_attributes.each { |answer_attribute| answers.create(answer_attribute) }
  end 

  def self.random
    ids = connection.select_all("SELECT id FROM polls")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end

  def validate
    # check name
    if name.blank?
      errors.add_to_base("名字不能为空")
    elsif name.length > 100
      errors.add_to_base("名字不能超过100个字符")
    end

    # check description
    errors.add_to_base("描述不能超过5000个字符") if description and description.length > 5000
    
    # check explanation
    errors.add_to_base("解释不能超过5000个字符") if explanation and explanation.length > 5000
    
    # check deadline
    errors.add_to_base("截止时间不能比现在早") if !no_deadline and deadline <= Time.now.to_date
    
    # check game_id
    if game_id.blank?
      errors.add_to_base("游戏类别不能为空")
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base("游戏不存在")
    end
  end

end

