require 'app/mailer/poll_mailer'

class PollObserver < ActiveRecord::Observer

  def before_create poll
    poll.auto_verify
  end

  def after_create poll
    # increment user's counter
    poll.poster.raw_increment :polls_count

    # issue feeds if necessary
    if poll.poster.application_setting.emit_poll_feed?
      poll.deliver_feeds
    end
  end

  def before_update poll
    poll.auto_verify 
  end
 
  def after_update poll
    if poll.recently_recovered
      poll.poster.raw_increment :polls_count
      User.update_all("participated_polls_count = participated_polls_count + 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
      poll.deliver_feeds
    elsif poll.recently_rejected
      poll.poster.raw_decrement :polls_count
      User.update_all("participated_polls_count = participated_polls_count - 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
      poll.destroy_feeds
    end
  end
 
  def before_destroy poll
    # decrement counter
    if !poll.rejected?
      poll.poster.raw_decrement :polls_count
      User.update_all("participated_polls_count = participated_polls_count - 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
    end

    # delete all votes
    poll.votes.each { |vote| vote.destroy_feeds }
    Vote.delete_all(:poll_id => poll.id)

    # decrement invitees' poll_invitations_count
    User.update_all("poll_invitations_count = poll_invitations_count - 1", {:id => poll.invitees.map(&:id)})

    # delete all invitations
    PollInvitation.delete_all(:poll_id => poll.id) 
  end

end
