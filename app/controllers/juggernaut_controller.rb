class JuggernautController < ApplicationController

  def subscription
    if current_user == User.find(params[:client_id])
      @info = {:login => current_user.login, :id => current_user.id, :avatar => avatar_path(current_user), :pinyin => current_user.pinyin}
      render :juggernaut => {:type => :send_to_clients, :client_ids => current_user.online_friends.map(&:id)} do |page|
        page << "Iyxzone.Chat.newOnlineFriend(#{@info.to_json})"
      end
      render :text => 'ok'
    else
    end
  end

  def broadcast
    render :text => 'ok'
  end

  def logout
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
