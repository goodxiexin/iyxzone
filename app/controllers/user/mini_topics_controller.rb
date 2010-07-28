class User::MiniTopicsController < UserBaseController

  layout 'app'

  TimeRange = [1.hours.ago, 6.hours.ago, 1.day.ago, 7.day.ago]

  def index
    @idx = params[:time].to_i
    @from = TimeRange[@idx]
    @to = Time.now
    @topics = MiniTopic.all.map{|t| [t.freq_within(@from, @to), t]}.sort{|a,b| b[0] <=> a[0]}.select{|a| a[0] > 0}[0..49]
  end

end
