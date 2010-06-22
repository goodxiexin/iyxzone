ActionController::IntegrationTest.class_eval do

  module CustomDsl
    def assert_not_found
      assert_template "errors/404"
    end
  end

  def login user
    open_session do |session|
      session.extend CustomDsl
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end
  end

  def image_data
    path = 'public/images/blank.gif'
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    ActionController::TestUploadedFile.new(path, mimetype)
  end

end
