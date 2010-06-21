require 'test_helper'

class ProfileFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @same_game_user = UserFactory.create
    @stranger = UserFactory.create
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    @idol_idol = UserFactory.create_idol
    @profile = @user.profile
    @idol_profile = @idol.profile

    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @same_game_user_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @same_game_user.id})
    @idol_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @idol.id})
    
    FriendFactory.create @user, @friend
    FriendFactory.create @idol, @friend
    FanFactory.create @fan, @idol
    FanFactory.create @idol, @idol_idol

    @region1 = RegionFactory.create
    @region2 = RegionFactory.create
    @city1 = CityFactory.create :region_id => @region1.id
    @city2 = CityFactory.create :region_id => @region2.id
    @district1 = DistrictFactory.create :city_id => @city1.id
    @district2 = DistrictFactory.create :city_id => @city2.id

    [@user, @friend, @same_game_user, @stranger, @idol, @fan, @idol_idol].each {|u| u.reload}
  
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @idol_sess = login @idol
    @fan_sess = login @fan
    @idol_idol_sess = login @idol_idol
  end

  test "GET /profiles/:id" do
    # normal user
    @user.privacy_setting.update_attributes(:profile => 1)
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:profile), @profile 
    end

    @user.privacy_setting.update_attributes(:profile => 2)
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:profile), @profile      
    end
    @stranger_sess.get "/profiles/#{@profile.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
 
    @user.privacy_setting.update_attributes(:profile => 3)
    [@user_sess, @friend_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:profile), @profile      
    end
    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end

    # idol
    [1, 2, 3].each do |p| 
      @idol.privacy_setting.update_attributes(:profile => p)
      [@idol_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_idol_sess].each do |sess|
        sess.get "/profiles/#{@idol_profile.id}"
        sess.assert_template "user/profiles/show"
        assert_equal sess.assigns(:profile), @idol_profile      
      end
    end
  end

  test "GET /profiles/:id with real page" do
    # create feeds

    # create friend suggestions

    # create viewings

    # create tags
  end

  test "PUT /profiles/:id" do
  end

end
