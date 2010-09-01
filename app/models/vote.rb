class Vote < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:voter_id => user_ids}}}

	serialize :answer_ids, Array

  belongs_to :voter, :class_name => 'User'

  belongs_to :poll

	acts_as_resource_feeds :recipients => lambda {|vote| 
    voter = vote.voter
    friends = voter.friends.all(:select => "id").find_all{|f| f.application_setting.recv_poll_feed?}
    ([voter.profile] + vote.poll.games + voter.all_guilds + friends + (voter.is_idol ? voter.fans.all(:select => "id") : [])).uniq
  }

  attr_readonly :voter_id, :poll_id, :answer_ids

  validates_presence_of :voter_id, :message => "不能为空"

  validates_presence_of :poll_id, :message => "不能为空"

  validate_on_create :poll_is_valid

  validates_presence_of :answer_ids, :message => "不能为空"

  validate_on_create :answers_are_valid

  def answers
    PollAnswer.find(answer_ids)
  end

protected

  def poll_is_valid
    return if poll_id.blank?
    poll = Poll.find(:first, :conditions => {:id => poll_id})
    if poll.blank?
      errors.add(:poll_id, "不存在")
    elsif poll.expired?
      errors.add(:poll_id, "已经过期")
    elsif !poll.is_votable_by? voter
      errors.add(:poll_id, "没有权限")
    elsif poll.voted_by? voter
      errors.add(:poll_id, "已经投过了")
    end
  end

  def answers_are_valid
    return if answer_ids.blank? or poll.blank?
    if poll.max_multiple < answer_ids.uniq.count
      errors.add(:answer_ids, "选太多了")
    elsif !poll.has_answers?(answer_ids.uniq)
      errors.add(:answer_ids, "选项不存在")
    end
  end

end
