class User::Guilds::FeedsController < UserBaseController

  FetchSize = 10

  FirstFetchSize = 10

  def index
    @feed_deliveries = @guild.feed_deliveries.limit(FirstFetchSize).order('created_at DESC')
    @first_fetch_size = FirstFetchSize
  end

  def more
    @feed_deliveries = @guild.feed_deliveries.offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FetchSize)
    @fetch_size = FetchSize 
  end

protected

  def setup
    @guild = Guild.find(params[:guild_id])
  end

end
