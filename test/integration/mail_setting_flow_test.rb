require 'test_helper'

class MailSettingFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    # login
    @user_sess = login @user
	end

	test "GET edit" do 
		@user_sess.get "/mail_setting/edit"
		@user_sess.assert_template "user/mail_setting/edit"
	end

  # 
  # XIEXIN
  # TODO
  # update
  test "PUT /mail_setting" do
  end

end
