class User::Friend::RequestsController < ApplicationController

	before_filter :login_required, :setup

	def new
	end

  def create
    @request = @recipient.friend_requests.build(params[:request].merge({:user_id => current_user.id}))
    if @request.save
      render :update do |page|
        page << "tip('成功，请耐心等待回复');"
      end
    else
      render :update do |page|
        page << "error('你已经发送过请求了，请等待回复');"
      end
    end  
  end

	def accept
		if @request.accept
			render :update do |page|
				page << "$('friend_request_option_#{@request.id}').innerHTML = '已接受';"
			end
		end		
	end

	def decline
		@request.destroy
		render :update do |page|
			page << "$('friend_request_option_#{@request.id}').innerHTML = '已拒绝';"
		end 
	end

protected

	def setup
		if ["new"].include? params[:action]
			@recipient = User.find(params[:friend_id])
		elsif ["create"].include? params[:action]
			@recipient = User.find(params[:request][:friend_id])
		elsif ["accept", "decline"].include? params[:action]
			@request = Friendship.find(params[:id])
		end
	rescue
		not_found
	end

# no longer needed due to form authenticity token
=begin
	def recipient_required
		current_user == @request.friend || not_found
	end
=end
end
