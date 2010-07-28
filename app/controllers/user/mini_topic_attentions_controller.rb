class User::MiniTopicAttentionsController < UserBaseController

  def create
    @attention = current_user.mini_topic_attentions.build params[:attention]
    
    if @attention.save
      render :json => {:code => 1, :id => @attention.id}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @attention.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['destroy'].include? params[:action]
      @attention = MiniTopicAttention.find(params[:id])
    end
  end

end
