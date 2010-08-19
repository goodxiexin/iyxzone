class PromotionsController < ApplicationController
	
  PER_PAGE = 10

	def dnpk
    @mini_blogs = MiniBlog.search('龙之谷pk赛').paginate :page => params[:page], :per_page => PER_PAGE
		render :action => 'dnpk', :layout => 'root2'
	end

end
