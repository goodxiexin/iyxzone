class PhotoFactory

  def self.create opts={}
    path = 'public/images/blank.gif' 
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    photo_type = opts.delete(:type)
    photo_type.camelize.constantize.create(opts.merge({:uploaded_data => ActionController::TestUploadedFile.new(path, mimetype)}))
  end

end