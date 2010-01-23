class Vote < ActiveRecord::Base

	serialize :answer_ids, Array

  belongs_to :voter, :class_name => 'User'

  belongs_to :poll#, :counter_cache => :voters_count

	acts_as_resource_feeds

	def answers
		PollAnswer.find(answer_ids)
	end

  def validate_on_create
    # check vote id
    if voter_id.blank?
      errors.add_to_base("没有投票者")
      return
    end

    # check poll id
    if poll_id.blank?
      errors.add_to_base("没有投票")
      return
    end

    # check selected options
    if answer_ids.blank?
      errors.add_to_base("没有选项")
      return
    elsif poll.max_multiple < answer_ids.count
      errors.add_to_base("选太多了")
      return
    end

    poll.answers.find(answer_ids)

    # check if voter has the required privilege
    unless poll.votable_by voter
      errors.add_to_base('权限不够')
      return false
    end

    # check if poll expires or voter has alread voted
    if poll.past
      errors.add_to_base('投票已经过期')
    elsif poll.voters.include? voter 
      errors.add_to_base("已经投过票了")
    end

  rescue
    errors.add_to_base("选项不存在")
  end

end
