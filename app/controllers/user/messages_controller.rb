class User::MessagesController < UserBaseController

  def index
    @messages = current_user.messages_with(@friends).paginate :page => params[:page], :per_page => 20
    @info = [].concat @messages.each {|m| {:content => m.content, :created_at => m.created_at, :poster_login => m.poster.login} } 
    render :json => @info
  end

  def read
    if Message.update_all("read = 1", {:id => params[:ids], :recipient_id => current_user.id})
      render :nothing => true
    end
  end

  def create
    message_params = (params[:message] || {}).merge({:poster_id => current_user.id, :recipient_id => @friend.id})
    @message = Message.new(message_params)
    if @message.save
      @info = {:content => @message.content, :created_at => @message.created_at}
      unless Juggernaut.show_client(@friend.id).nil?
        @message.update_attributes(:read => true)
        render :juggernaut => {:type => :send_to_client, :client_id => @friend.id} do |page|
          page << "Iyxzone.Chat.recvMessage(#{@info.to_json}, #{current_user.id}, '#{form_authenticity_token}')" 
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
