class Admin::NewsPicturesController < AdminBaseController

  protect_from_forgery :except => [:create]

  def create
    @news = News.find(params[:news_id])
    @picture = @news.pictures.build(:swf_uploaded_data => params[:Filedata])
    
    if @picture.save
      render :nothing => true
    end
  end

end
