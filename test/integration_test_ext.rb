ActionController::IntegrationTest.class_eval do

protected

  def image_data
    path = 'public/images/default_male_large.png'
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    ActionController::TestUploadedFile.new(path, mimetype)
  end

  def login user
    open_session do |sess| 
      sess.post "/sessions", :email => user.email, :password => user.password
      sess.assert_redirected_to "/home"
    end  
  end

end

ActionController::Integration::Session.class_eval do

  def assert_not_found
    self.assert_template "errors/404"
  end

end
