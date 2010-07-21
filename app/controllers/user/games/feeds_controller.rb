class User::Games::FeedsController < UserBaseController

  FetchSize = 10

  FirstFetchSize = 10

  def index
    @feed_deliveries = @game.feed_deliveries.limit(FirstFetchSize).order('created_at DESC')
    @first_fetch_size = FirstFetchSize
  end

  def more
    @feed_deliveries = @game.feed_deliveries.offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FetchSize)
    @fetch_size = FetchSize 
  end

protected

  def setup
    @game = Game.find(params[:game_id])
  end

end
