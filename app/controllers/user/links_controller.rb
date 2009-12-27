class User::LinksController < ApplicationController

  before_filter :login_required, :setup

  def show
  end

protected

  def setup
    @link = Link.find(params[:id])
    @sharing = @link.sharing
    @user = @sharing.poster
  rescue
    not_found
  end

end
