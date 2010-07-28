class User::MiniTopicsController < UserBaseController

  layout 'app'

  TimeRange = [6.hours.ago, 24.hours.ago, 2.day.ago, 7.day.ago]

  def index
    @idx = params[:time].to_i
    @from = TimeRange[@idx]
    @to = Time.now
    @topics = MiniTopic.hot(@from, @to).select{|a| a[0] > 0}[0..49]
  end

end
