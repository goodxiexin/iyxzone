class User::MiniImagesController < UserBaseController

  def create
    @image = current_user.mini_images.build(params[:mini_image])

    if @image.save
      respond_to_parent do
        render_js_code "Iyxzone.MiniBlog.Builder.imageUploaded(#{@image.id}, '#{@image.filename}', '#{@image.public_filename(:large)}')"
      end
    else
      respond_to_parent do
        render_js_error
      end
    end  
  end

  def destroy
    if @image.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @image = current_user.mini_images.find(params[:id])
    end
  end

end
