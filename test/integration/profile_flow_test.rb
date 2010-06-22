require 'test_helper'

class ProfileFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @same_game_user = UserFactory.create
    @stranger = UserFactory.create
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    @profile = @user.profile
    @idol_profile = @idol.profile

    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @same_game_user_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @same_game_user.id})
    @idol_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @idol.id})
    @game = @user_character.game
    
    FriendFactory.create @user, @friend
    FanFactory.create @user, @idol

    @region1 = RegionFactory.create
    @region2 = RegionFactory.create
    @city1 = CityFactory.create :region_id => @region1.id
    @city2 = CityFactory.create :region_id => @region2.id
    @district1 = DistrictFactory.create :city_id => @city1.id
    @district2 = DistrictFactory.create :city_id => @city2.id

    [@user, @friend, @same_game_user, @stranger, @idol, @fan].each {|u| u.reload}
  
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @idol_sess = login @idol
    @fan_sess = login @fan
  end
  
  test "GET /profiles/:id with real page" do
    # create feeds
    # blog
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    assert @profile.reload.recv_feed?(@blog)    

    # blog sharing
    @blog.share_by @user, 'r', 't'
    @sharing = Sharing.last
    assert @profile.reload.recv_feed?(@sharing)
    
    # video
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    assert @profile.reload.recv_feed?(@video)

    # video sharing
    @video.share_by @user, 'r', 't'
    @sharing = Sharing.last
    assert @profile.reload.recv_feed?(@sharing)

    # status
    @status = StatusFactory.create :poster_id => @user.id
    assert @profile.reload.recv_feed?(@status)
 
    # poll
    @poll = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    assert @profile.reload.recv_feed?(@poll)
    
    # vote
    @vote = @poll.votes.create :voter_id => @user.id, :answer_ids => [@poll.answers.first.id]
    assert @profile.reload.recv_feed?(@vote) 

    # event
    @event = EventFactory.create :character_id => @user_character.id
    assert @profile.reload.recv_feed?(@event)    

    # participation
    @friend_event = EventFactory.create :character_id => @friend_character.id
    @invitation = @friend_event.invitations.create :participant_id => @user.id, :character_id => @user_character.id
    @invitation.accept_invitation Participation::Confirmed
    assert @profile.reload.recv_feed?(@invitation)

    # guildnger_sess.assert_redirected_to
    @guild = GuildFactory.create :character_id => @user_character.id
    assert @profile.reload.recv_feed?(@guild)

    # membership
    @friend_guild = GuildFactory.create :character_id => @friend_character.id
    @invitation = @friend_guild.invitations.create :user_id => @user.id, :character_id => @user_character.id
    @invitation.accept_invitation
    assert @profile.reload.recv_feed?(@invitation)

    # friendship
    @new_user = UserFactory.create
    @request = @new_user.friend_requests.create :user_id => @user.id
    @request.accept
    assert @profile.reload.recv_feed?(@request)

    # album/photo
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @avatar_album = @user.avatar_album
    @event_album = @event.album
    @guild_album = @guild.album
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @avatar = PhotoFactory.create :album_id => @avatar_album.id, :type => 'Avatar'
    @event_photo = PhotoFactory.create :album_id => @event_album.id, :type => 'EventPhoto'
    @guild_photo = PhotoFactory.create :album_id => @guild_album.id, :type => 'GuildPhoto'
    @album.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @photo.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @avatar_album.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @avatar.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @event_album.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @event_photo.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @guild_album.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)
    @guild_photo.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)

    # topic share
    @topic = TopicFactory.create :forum_id => @guild.forum.id, :poster_id => @user.id
    @topic.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)

    # profile share
    @idol_profile.share_by @user
    assert @profile.reload.recv_feed?(Sharing.last)

    # news
    # TODO

    # create friend suggestions
    @user.create_friend_suggestions

    # create viewings
    @profile.viewed_by @friend
    @profile.viewed_by @same_game_user

    # create tags
    assert_difference "Tagging.count", 2 do
      @profile.add_tag @friend, 'sb'
      @profile.add_tag @new_user, 'chunge'
    end

    # normal people
    @feed_deliveries = @profile.reload.feed_deliveries
    @user.privacy_setting.update_attributes(:profile => 1)
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[0..9]
      cnt = @feed_deliveries.count / 10
      cnt.times do |idx|
        sess.get "/profiles/#{@profile.id}/more_feeds", {:idx => idx}
        assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[(10*(idx+1))..(10*(idx+2))]
      end
    end
    
    @user.privacy_setting.update_attributes(:profile => 2)
    [@user_sess, @friend_sess, @same_game_user_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[0..9]
      cnt = @feed_deliveries.count / 10
      cnt.times do |idx|
        sess.get "/profiles/#{@profile.id}/more_feeds", {:idx => idx}
        assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[(10*(idx+1))..(10*(idx+2))]
      end
    end
    @stranger_sess.get "/profiles/#{@profile.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
    @user.privacy_setting.update_attributes(:profile => 3)
    [@user_sess, @friend_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_template "user/profiles/show"
      assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[0..9]
      cnt = @feed_deliveries.count / 10
      cnt.times do |idx|
        sess.get "/profiles/#{@profile.id}/more_feeds", {:idx => idx}
        assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[(10*(idx+1))..(10*(idx+2))]
      end
    end
    
    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}"
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end

    # idol
    @user.is_idol = true
    @user.save
    FanFactory.create @fan, @user

    [1, 2, 3].each do |p|
      @user.privacy_setting.update_attributes(:profile => p)
      [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
        sess.get "/profiles/#{@profile.id}"
        sess.assert_template "user/profiles/show"
        assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[0..9]
        cnt = @feed_deliveries.count / 10
        cnt.times do |idx|
          sess.get "/profiles/#{@profile.id}/more_feeds", {:idx => idx}
          assert_equal sess.assigns(:feed_deliveries), @feed_deliveries[(10*(idx+1))..(10*(idx+2))]
        end
      end
    end 
  end

  test "PUT /profiles/:id" do
    # normal people
    @user.privacy_setting.update_attributes(:profile => 1)
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}/edit"
      sess.assert_template "user/profiles/edit"
    end

    @user.privacy_setting.update_attributes(:profile => 2)
    [@user_sess, @friend_sess, @same_game_user_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}/edit"
      sess.assert_template "user/profiles/edit"
    end
    @stranger_sess.get "/profiles/#{@profile.id}/edit"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @user.privacy_setting.update_attributes(:profile => 3)
    [@user_sess, @friend_sess, @idol_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}/edit"
      sess.assert_template "user/profiles/edit"
    end
    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/profiles/#{@profile.id}/edit"
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end
   
    # idol
    @user.is_idol = true
    @user.save
    FanFactory.create @fan, @user

    [1,2,3].each do |p|
      @user.privacy_setting.update_attributes :profile => p
      [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
        sess.get "/profiles/#{@profile.id}/edit"
        sess.assert_template "user/profiles/edit"
      end
    end
  end
  
  test "update profile" do
    # update basic info
    @user_sess.put "/profiles/#{@profile.id}", {:profile => {:gender => 'female'}}
    assert_equal @user.reload.gender, 'female'

    @user_sess.put "/profiles/#{@idol_profile.id}", {:profile => {:gender => 'female'}}
    @user_sess.assert_not_found

    @user_sess.put "/profiles/invalid", {:profile => {:gender => 'female'}}
    @user_sess.assert_not_found

    # update contact info
    @user_sess.put "/profiles/#{@profile.id}", {:profile => {:qq => '12345678'}}
    assert_equal @profile.reload.qq, '12345678'
  
    # update character info
    assert_difference "GameCharacter.count" do
      @user_sess.put "/profiles/#{@profile.id}", {:profile => {:new_characters => {"1" => @user_character.game_info.merge({:name => 'c', :level => '1'})}}}
    end
    @new_character = GameCharacter.last

    assert_no_difference "GameCharacter.count" do
      @user_sess.put "/profiles/#{@profile.id}", {:profile => {:new_characters => {"1" => @user_character.game_info.merge({:name => nil, :level => '1'})}}}
    end

    @user_sess.put "/profiles/#{@profile.id}", {:profile => {:existing_characters => {@new_character.id => {:name => 'new name'}}}}
    assert_equal @new_character.reload.name, 'new name'
  
    assert_difference "GameCharacter.count", -1 do
      @user_sess.put "/profiles/#{@profile.id}", {:profile => {:del_characters => [@new_character.id]}}
    end

    assert_no_difference "GameCharacter.count" do
      @user_sess.put "/profiles/#{@profile.id}", {:profile => {:del_characters => ['invalid']}}
    end

  end

end
