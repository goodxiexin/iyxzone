class JuggernautController < ApplicationController

  protect_from_forgery :except => [:subscription, :broadcast, :logout]

  def subscription
    # create online user
    @online_user = OnlineUser.find_or_create(:user_id => params[:client_id], :session_id => params[:session_id])

    # tell your friends you are online !!!
    @user = @online_user.user
    @online_friend_ids = @online_user.online_friend_ids
    render :juggernaut => {:type => :send_to_clients, :client_ids => @online_friend_ids} do |page|
      page << "Iyxzone.Chat.newOnlineFriend(#{ {:pinyin => @user.pinyin, :id => @user.id, :login => @user.login, :avatar => avatar_path(@user)}.to_json })"
    end

    # send new user his online friends and unread messages
    # 我觉得这个很危险，毕竟这个用户还没被juggernaut接受，那我怎么能肯定下面这些请求不会被juggernaut拒绝
    # 不过还好的是，下面的请求没被拒绝，但还是很危险
    @online_friend_infos = User.find(@online_friend_ids).map {|f| {:login => f.login, :id => f.id, :avatar => avatar_path(f), :pinyin => f.pinyin}}
    @unread_messages = {}
    @info = {:avatar => avatar_path(@user), :login => @user.login}
    @user.unread_messages.group_by(&:poster).each do |poster, messages|
      @unread_messages["#{poster.id}"] = {
        :login => poster.login,
        :avatar => avatar_path(poster),
        :messages => messages.map{|m| {:content => m.content, :created_at => m.created_at, :id => m.id}}
      }
    end
    render :juggernaut => {:type => :send_to_client, :client_id => @user.id} do |page|
      page << "Iyxzone.Chat.set(#{@online_friend_infos.to_json}, #{integer_array_for_javascript @unread_messages.keys}, #{@unread_messages.values.to_json}, '#{form_authenticity_token}', #{@info.to_json});"
    end

    # tell juggernaut this user is verified
    render :text => 'ok'
  end

  def broadcast
    render :text => 'ok'
  end

  def logout
    # tell your online friends that you are offline
    @online_user = OnlineUser.find(:first, :conditions => {:user_id => params[:client_id], :session_id => params[:session_id]})
    @online_friend_ids = @online_user.online_friend_ids
    @user = @online_user.user
    render :juggernaut => {:type => :send_to_clients, :client_ids => @online_friend_ids} do |page|
      page << "Iyxzone.Chat.friendOffline(#{@user.id});"
    end

    # destroy record
    @online_user.destroy

    # tell juggernaut it's okay
    render :text => 'ok'
  end

  def avatar_path user
    if user.avatar.blank?
      "/images/default_#{user.gender}_small.png"
    else
      user.avatar.public_filename(:small)
    end
  end

end
