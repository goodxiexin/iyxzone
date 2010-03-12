class User::MessagesController < UserBaseController

  def index
    @messages = current_user.messages_with(@friend).paginate :page => params[:page], :per_page => 3
    @remote = {:update => "chat-history-#{@friend.id}", :url => {:action => 'index', :friend_id => @friend.id}}
    render :partial => 'history' # 由于不会javascript下的分页，所以只能这样了
  end

  def read
    if Message.update_all("messages.read = 1", {:id => params[:ids], :recipient_id => current_user.id})
      render :nothing => true
    end
  end

  def create
    message_params = (params[:message] || {}).merge({:poster_id => current_user.id, :recipient_id => @friend.id})
    @message = Message.new(message_params)
    if @message.save
      @info = {:content => @message.content, :created_at => @message.created_at, :id => @message.id}
      unless Juggernaut.show_client(@friend.id).nil?
        render :juggernaut => {:type => :send_to_client, :client_id => @friend.id} do |page|
          page << "Iyxzone.Chat.recvMessage(#{@info.to_json}, '#{current_user.login}', #{current_user.id})" 
        end
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
  end

end
