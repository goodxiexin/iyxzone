require 'app/mailer/poll_mailer'

#
# 如果投票的小结出来了，通知大家
# 不过小结目前在投票中没有实现，觉得没有必要
#
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
