require 'test_helper'

class MailSettingFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    # login
    @user_sess = login @user
	end

	test "GET edit & PUT update" do 
		@user_sess.get "/mail_setting/edit"
		@user_sess.assert_template "user/mail_setting/edit"

		@user_sess.put "/mail_setting", {:setting => {:birthday => 1}}
		assert_equal @user.reload.mail_setting.birthday, 1
	end

end
