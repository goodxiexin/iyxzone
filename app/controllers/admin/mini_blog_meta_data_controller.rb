class Admin::MiniBlogMetaDataController < AdminBaseController

  def show
    render :action => 'show'
  end

  def update
    if @meta_data.update_attributes(params[:mini_blog_meta_data])
      flash[:notice] = "成功"
      redirect_to admin_mini_blog_meta_data_url
    else
      render :action => 'show'
    end
  end

protected

  def setup
    @meta_data = MiniBlogMetaData.first
  end

end

