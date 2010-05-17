class PollAnswerObserver < ActiveRecord::Observer

  def after_create answer
    # verify
    if answer.sensitive?
      poll = answer.poll
      poll.needs_verify
      poll.save
    end
  end

end
