require 'test_helper'

class SearchFlowTest < ActionController::IntegrationTest
	def setup
		Pinyin.init_db
    @user1 = UserFactory.create :login => "风中", :email => "feng@gmail.com"
    @character1 = GameCharacterFactory.create :user_id => @user1.id, :name => "风中"
	
    @user2 = UserFactory.create :login => "fengzhong"
    @character2 = GameCharacterFactory.create :user_id => @user2.id, :name => "windnap"
	
    @user3 = UserFactory.create :login => "雨人", :email => "yu@gmail.com"
    @character3 = GameCharacterFactory.create :user_id => @user3.id, :name => "fengzhong"

    @user1_sess = login @user1
    @user2_sess = login @user2
    @user3_sess = login @user3
	end

	test "GET user" do
		@user1_sess.get "/search_users?key=feng"
		@user1_sess.assert_template 'user/search/user'
		assert_equal @user1_sess.assigns(:users), [@user1, @user2]

		@user1_sess.get "/search_users?key=hehe"
		@user1_sess.assert_template 'user/search/user'
		assert_equal @user1_sess.assigns(:users), []

		@user1_sess.get "/search_users?key=风"
		@user1_sess.assert_template 'user/search/user'
		assert_equal @user1_sess.assigns(:users), [@user1]

		@user1_sess.get "/search_users?key=不要"
		@user1_sess.assert_template 'user/search/user'
		assert_equal @user1_sess.assigns(:users), []
	end
	
	test "GET character" do

		@user1_sess.get "/search_characters?key=feng&game_id=&area_id=&server_id="
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), [[1,[@character1]],[3, [@character3]]]

		@user1_sess.get "/search_characters?key=feng&game_id=#{@character1.game.id}&area_id=#{@character1.area.id}&server_id=#{@character1.server.id}"
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), [[1,[@character1]]]

		@user1_sess.get "/search_characters?key=feng&game_id=#{@character2.game.id}&area_id=#{@character2.area.id}&server_id=#{@character2.server.id}"
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), []

		@user1_sess.get "/search_characters?key=hehe&game_id=&area_id=&server_id="
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), []

		@user1_sess.get "/search_characters?key=风&game_id=&area_id=&server_id="
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), [[1,[@character1]]]

		@user1_sess.get "/search_characters?key=不要&game_id=&area_id=&server_id="
		@user1_sess.assert_template 'user/search/character'
		assert_equal @user1_sess.assigns(:users), []

	end

end
