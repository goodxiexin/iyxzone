class User::MiniTopicsController < UserBaseController

  layout 'app'

  RANGE = [6.hours.ago, 1.day.ago, 2.days.ago, 1.week.ago]

  # 这个也可以弄成page cache，这样更快，但是就需要重写url，这会丧失些可读性，而且还需要加上个cron任务
  def index
    @idx = params[:time].to_i
    @from = RANGE[@idx]
    @to = Time.now
    @meta_data = MiniBlogMetaData.first
    @topics = @meta_data.hot_topics[@idx].map{|a| [a[0], MiniTopic.find_by_name(a[1])]}
  end

end
