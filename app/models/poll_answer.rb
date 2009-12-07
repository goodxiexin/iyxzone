class PollAnswer < ActiveRecord::Base

  belongs_to :poll, :counter_cache => :answers_count

end
