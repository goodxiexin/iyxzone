class JuggernautController < ApplicationController

  protect_from_forgery :except => [:subscription, :broadcast, :logout]

  def subscription
    @user = User.find(params[:client_id])
    @info = {:avatar => avatar_path(@user), :login => @user.login}
    @friends = @user.friends
    
    render :juggernaut => {:type => :send_to_clients, :client_ids => @friends.map(&:id)} do |page|
      page << "Iyxzone.Chat.newOnlineFriend(#{ {:pinyin => @user.pinyin, :id => @user.id, :login => @user.login, :avatar => avatar_path(@user)}.to_json })"
    end
    
    render :text => 'ok'
  end

  def broadcast
    render :text => 'ok'
  end

  def logout
    @user = User.find(params[:client_id])
    @friends = @user.friends
    render :juggernaut => {:type => :send_to_clients, :client_ids => @friends.map(&:id)} do |page|
      page << "Iyxzone.Chat.friendOffline(#{@user.id});"
    end
    render :text => 'ok'
  end

  def avatar_path user
    if user.avatar.blank?
      "/images/default_medium.png"
    else
      user.avatar.public_filename(:medium)
    end
  end

end
