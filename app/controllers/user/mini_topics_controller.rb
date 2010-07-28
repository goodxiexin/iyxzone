class User::MiniTopicsController < UserBaseController

  layout 'app'

  TimeRange = [Time.now, Time.now.beginning_of_day, 1.day.ago.beginning_of_day, 7.day.ago.beginning_of_day, 365.day.ago.beginning_of_day]

  def index
    @idx = params[:time].to_i
    @from = TimeRange[@idx+1]
    @to = TimeRange[@idx]
    @topics = MiniTopic.within(@from, @to).order('created_at DESC').group_by(&:name).map do |name, topics|
      from_topic = MiniTopic.find(:first, :conditions => ["name = ? and created_at < ?", name, topics.first.created_at], :order => "created_at DESC")
      to_topic = MiniTopic.find(:first, :conditions => ["name = ? and created_at > ?", name, topics.last.created_at], :order => "created_at ASC")
      from_freq = from_topic.blank? ? 0 : from_topic.freq
      to_freq = to_topic.blank? ? 0 : to_topic.freq
      [name, (to_freq - from_freq)]
    end
  end

end
