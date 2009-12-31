class Admin::UsersController < ApplicationController

  #before_filter :login_required
  require_login

  require_role 'admin'

  def index
    render :text => 'this is index page'
  end

end
