class User::LinksController < ApplicationController

  def create
    @link = Link.new(params[:link])
    if @link.save
      render :update do |page|
        page << ".redirect_to sharings_url(:id => current_user.id)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

end
