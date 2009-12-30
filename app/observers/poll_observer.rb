require 'app/mailer/poll_mailer'

class PollObserver < ActiveRecord::Observer

  def after_update(poll)
    if poll.summary_changed?
      poll.voters.each do |voter|
        if voter.mail_setting.poll_summary_change and voter != poll.poster
          PollMailer.deliver_summary_change poll, voter
        end
      end
    end
  end

end
