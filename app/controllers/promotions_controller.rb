class PromotionsController < ApplicationController
	
  PER_PAGE = 10

	def create
		self.current_user = User.authenticate(params[:email], params[:password])
		if current_user.nil?
			flash.now[:error] = "您的用户名或者密码输入不正确"
			redirect_to :controller => 'sessions', :action => 'index', :layout => 'root'
		else
			redirect_to :controller => 'promotions', :action => 'dnpk'
		end
	end

	def dnpk
    @mini_blogs = MiniBlog.search('龙之谷pk赛').paginate :page => params[:page], :per_page => PER_PAGE
		render :action => 'dnpk', :layout => 'root2'
	end

end
