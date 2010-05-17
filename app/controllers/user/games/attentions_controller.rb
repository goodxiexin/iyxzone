class User::Games::AttentionsController < UserBaseController

  def create
    @game = Game.find(params[:game_id])
    @attention = @game.attentions.build(:user_id => current_user.id)

    unless @attention.save
      render_js_error
    end
  end

  def destroy
    @attention = GameAttention.find(params[:id])

    unless @attention.destroy
      render_js_error
    end
  end

end
