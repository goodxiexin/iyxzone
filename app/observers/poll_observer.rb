require 'app/mailer/poll_mailer'

class PollObserver < ActiveRecord::Observer

  def after_create poll
    # verify
    # 如果是投票的选项是sensitive的，那是在poll_answer的after_create里判断的
    if poll.sensitive?
      poll.verified = 0
    else
      poll.verified = 1
    end

    # increment user's counter
    poll.poster.raw_increment :polls_count

    # issue feeds if necessary
    if poll.poster.application_setting.emit_poll_feed == 1
      poll.deliver_feeds
    end
  end

  def before_update poll 
    if poll.sensitive_columns_changed? and poll.sensitive?
      poll.verified = 0
    end
  end
 
  def after_update poll
    if poll.verified_changed?
      if poll.verified_was == 2 and poll.verified == 1
        poll.poster.raw_increment :polls_count
        User.update_all("participated_polls_count = participated_polls_count + 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
      elsif (poll.verified_was == 0 or poll.verified_was == 1) and poll.verified == 2
        poll.poster.raw_decrement :polls_count
        User.update_all("participated_polls_count = participated_polls_count - 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
      end
    end
  end
 
  def before_destroy poll
    # decrement counter
    if poll.verified != 2
      poll.poster.raw_decrement :polls_count
      User.update_all("participated_polls_count = participated_polls_count - 1", {:id => (poll.voters - [poll.poster]).map(&:id)})
    end

    # delete all votes
    Vote.delete_all(:poll_id => poll.id)

    # decrement invitees' poll_invitations_count
    User.update_all("poll_invitations_count = poll_invitations_count - 1", {:id => poll.invitees.map(&:id)})

    # delete all invitations
    PollInvitation.delete_all(:poll_id => poll.id) 
  end

end
