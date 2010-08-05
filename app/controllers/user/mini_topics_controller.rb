class User::MiniTopicsController < UserBaseController

  layout 'app'

  TimeRange = [6.hours.ago, 24.hours.ago, 2.day.ago, 7.day.ago]

  # 这个也可以弄成page cache，这样更快，但是就需要重写url，这会丧失些可读性，而且还需要加上个cron任务
  def index
    @idx = params[:time].to_i
    MiniTopic
    MiniTopicFreqNode
    Rails.cache.fetch("hot_topics_#{@idx}", :expires_in => 15.minutes) do
      @from = TimeRange[@idx]
      @to = Time.now
      @topics = MiniTopic.hot_within(@from, @to).select{|a| a[0] > 0}[0..49]
    end
  end

end
