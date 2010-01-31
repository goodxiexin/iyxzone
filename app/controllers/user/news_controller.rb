class User::NewsController < ApplicationController
  def index
    @news_list = News.find(:all, :limit => 10, :order => 'created_at DESC')
  end

  def show
    @news = News.find(params[:id])
    if @news.nil?
      render :update do |page|
        page << "error('发生错误')"
      end
    end
  end

end
