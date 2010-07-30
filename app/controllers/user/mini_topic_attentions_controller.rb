class User::MiniTopicAttentionsController < UserBaseController

  def create
    @attention = current_user.mini_topic_attentions.build(:topic_name => params[:name])
    
    if @attention.save
      render :json => {:code => 1, :id => @attention.id}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    @attention = current_user.mini_topic_attentions.find(params[:id])

    if @attention.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

end
