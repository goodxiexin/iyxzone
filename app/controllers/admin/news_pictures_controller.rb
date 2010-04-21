class Admin::NewsPicturesController < AdminBaseController

  protect_from_forgery :except => [:create]

  def create
    @picture = @news.pictures.build(:swf_uploaded_data => params[:Filedata])
    
    if @picture.save
      render :nothing => true
    end
  end

  def edit_multiple
    @pictures = @news.pictures
  end

  def update_multiple
    params[:pictures].each do |id, attributes|
      picture = @news.pictures.find(id)
      picture.update_attributes(attributes)
    end
    redirect_to news_index_url
  end 

protected

  def setup
    @news = News.find(params[:news_id])
  end

end
