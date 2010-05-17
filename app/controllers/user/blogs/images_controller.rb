class User::Blogs::ImagesController < UserBaseController
  
  def create
    @image = BlogImage.new(params[:photo])
    if @image.save
      responds_to_parent do
        render_js_code "nicImageButton.statusCb({'url':'#{@image.public_filename}', 'width':'#{@image.width}'});"  
      end
    else
      render_js_error "error('保存图片的时候发生错误');"
    end
  end

end
