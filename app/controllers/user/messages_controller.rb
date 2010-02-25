class User::MessagesController < UserBaseController

  def index
    @messages = current_user.messages_with @friend
    @info = []
    @messages.each do |m|
      @info << {:content => m.content, :created_at  => m.created_at, :poster_login => m.poster.login}
    end
    render :json => @info
  end

  def create
    message_params = (params[:message] || {}).merge({:poster_id => current_user.id, :recipient_id => @friend.id})
    @message = Message.new(message_params)
    if @message.save
      @info = {:content => @message.content, :created_at => @message.created_at, :poster_login => @message.poster.login}
      render :juggernaut => {:type => :send_to_client, :client_id => @friend.id} do |page|
        page << "Iyxzone.Chat.insertMessage(#{@info.to_json}, #{current_user.id}, '#{form_authenticity_token}')" 
      end
      render :json => @info 
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ["index", "create"].include? params[:action]
      @friend =  current_user.friends.find(params[:friend_id])
    end
  rescue
    not_found
  end

end
