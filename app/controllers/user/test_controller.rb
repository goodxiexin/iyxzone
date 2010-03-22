class User::TestController < ApplicationController

  def index
  end

  def show
    render :text => 'this is show'
  end

end
