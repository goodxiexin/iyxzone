class PollAnswerObserver < ActiveRecord::Observer

  def after_create answer
    # verify
    answer.poll.needs_verify if answer.sensitive?
  end

end
