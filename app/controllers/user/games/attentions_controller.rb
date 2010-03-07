class User::Games::AttentionsController < UserBaseController

  def create
    @game = Game.find(params[:game_id])
    @attention = @game.attentions.build(:user_id => current_user.id)
    unless @attention.save
      render :update do |page|
        page << "error('发生错误，稍后再试');"
      end
    end
  end

  def destroy
    unless @attention.destroy
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @attention = GameAttention.find(params[:id])
      @game = @attention.game
      require_owner @attention.user
    end
  end

end
