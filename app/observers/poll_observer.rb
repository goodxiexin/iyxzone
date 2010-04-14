require 'app/mailer/poll_mailer'

#
# 如果投票的小结出来了，通知大家
# 不过小结目前在投票中没有实现，觉得没有必要
#
class PollObserver < ActiveRecord::Observer

  def after_create poll
    # increment user's counter
    poll.poster.raw_increment :polls_count

    # issue feeds if necessary
    return if poll.poster.application_setting.emit_poll_feed == 0
    recipients = [poll.poster.profile, poll.game]
    recipients.concat poll.poster.guilds
    recipients.concat poll.poster.friends.find_all{|f| f.application_setting.recv_poll_feed == 1}
    poll.deliver_feeds :recipients => recipients
  end

  # update verified column
  def before_update poll 
    if poll.name_changed? or poll.explanation_changed? or poll.description_changed? 
      poll.verified = 0
    end
  end
  
  def before_destroy poll
    # decrement poster's polls_count
    poll.poster.raw_decrement :polls_count

    # decrement voters' participated_polls_count
    (poll.voters - [poll.poster]).each do |voter|
      voter.raw_decrement :participated_polls_count
    end

    # delete all votes
    Vote.delete_all(:poll_id => poll.id)

    # decrement invitees' poll_invitations_count
    poll.invitees.each do |invitee|
      invitee.raw_decrement :poll_invitations_count
    end

    # delete all invitations
    PollInvitation.delete_all(:poll_id => poll.id) 
  end

end
