class PollAnswerObserver < ActiveRecord::Observer

  def after_create answer
    # verify
    if answer.sensitive?
      poll = answer.poll
      poll.verified = 0
      poll.save
    end
  end

end
