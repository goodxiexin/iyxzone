require 'test_helper'

class GuildPhotoFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create_idol 
    @friend = UserFactory.create 
    @stranger = UserFactory.create 
    @same_game_user = UserFactory.create 
    @fan = UserFactory.create 
    @idol = UserFactory.create_idol 

    FriendFactory.create @user, @friend
    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @same_game_user_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @same_game_user.id})
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id

    @guild = GuildFactory.create :character_id => @user_character.id
    @album = @guild.album
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id
    @guild.veteran_memberships.create :user_id => @same_game_user.id, :character_id => @same_game_user_character.id
    
    # login
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @fan_sess = login @fan
    @idol_sess = login @idol

    @sensitive = "政府"

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|f| f.reload}
  end

  test "GET /guild_albums/:id" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    sleep 1
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess| 
      sess.get "/guild_albums/#{@album.id}"
      sess.assert_template "user/guilds/albums/show"
      assert_equal sess.assigns(:photos), [@photo2, @photo1]
    end

    @user_sess.get "/guild_albums/invalid"
    @user_sess.assert_not_found

    @album.unverify
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_albums/#{@album.id}"
      sess.assert_not_found
    end
  end

  test "PUT /guild_albums/:id" do
    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.put "/guild_albums/#{@album.id}", {:album => {:description => 'new description'}}
      sess.assert_not_found
    end

    @user_sess.put "/guild_albums/#{@album.id}", {:album => {:description => 'new'}}
    @album.reload
    assert_equal @album.description, 'new'

    @user_sess.put "/guild_albums/invalid", {:album => {:description => 'new'}}
    @user_sess.assert_not_found

    @album.unverify
    @user_sess.put "/guild_albums/#{@album.id}", {:album => {:description => 'new'}}
    @user_sess.assert_not_found
  end

  test "POST /guild_photos" do
    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_photos/new", {:album_id => @album.id}
      sess.assert_not_found
    end

    @user_sess.get "/guild_photos/new", {:album_id => 'invalid'}
    @user_sess.assert_not_found

    @album.unverify
    @user_sess.get "/guild_photos/new", {:album_id => @album.id}
    @user_sess.assert_not_found
    @album.verify

    @user_sess.get "/guild_photos/new", {:album_id => @album.id}
    @user_sess.assert_template 'user/guilds/photos/new'
    assert_equal @user_sess.assigns(:album), @album

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.post "/guild_photos", {:album_id => @album.id, :Filedata => image_data}
      sess.assert_not_found
    end

    @user_sess.post "/guild_photos", {:album_id => 'invalid', :Filedata => image_data}
    @user_sess.assert_not_found

    assert_difference "@album.reload.photos.count" do
      @user_sess.post "/guild_photos", {:album_id => @album.id, :Filedata => image_data}
    end
  end

  test "record upload" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
  
    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.post "/guild_photos/record_upload", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id]}
      sess.assert_not_found
    end

    @user_sess.post "/guild_photos/record_upload", {:album_id => 'invalid', :ids => [@photo1.id, @photo2.id]}
    @user_sess.assert_not_found

    @user_sess.post "/guild_photos/record_upload", {:album_id => @album.id, :ids => ['invalid', @photo2.id]}
    @user_sess.assert_not_found

    @album.unverify
    @user_sess.post "/guild_photos/record_upload", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id]}
    @user_sess.assert_not_found
    @album.verify

    @user_sess.post "/guild_photos/record_upload", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id]}
    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album)
    assert @fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)
  end

  test "edit/update multiple" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    sleep 1
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_photos/edit_multiple", {:ids => [@photo1.id, @photo2.id], :album_id => @album.id}
      sess.assert_not_found
    end

    @user_sess.get "/guild_photos/edit_multiple", {:ids => [@photo1.id], :album_id => 'invalid'}
    @user_sess.assert_not_found
    @user_sess.get "/guild_photos/edit_multiple", {:ids => [@photo1.id, 'invalid'], :album_id => @album.id}
    @user_sess.assert_not_found
    @album.unverify
    @user_sess.get "/guild_photos/edit_multiple", {:ids => [@photo1.id], :album_id => @album.id}
    @user_sess.assert_not_found
    @album.verify

    @user_sess.get "/guild_photos/edit_multiple", {:ids => [@photo1.id, @photo2.id], :album_id => @album.id}
    @user_sess.assert_template "user/guilds/photos/edit_multiple"
    assert_equal @user_sess.assigns(:photos), [@photo2, @photo1]

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.put "/guild_photos/update_multiple", {:photos => {@photo1.id => {:notation => 'n'}}, :album_id => @album.id}
      sess.assert_not_found
    end

    @user_sess.put "/guild_photos/update_multiple", {:photos => {@photo1.id => {:notation => 'n'}}, :album_id => 'invalid'}
    @user_sess.assert_not_found
    @user_sess.put "/guild_photos/update_multiple", {:photos => {'invalid' => {:notation => 'n'}}, :album_id => @album.id}
    @user_sess.assert_not_found
    @photo1.unverify
    @user_sess.put "/guild_photos/update_multiple", {:photos => {@photo1.id => {:notation => 'n'}}, :album_id => @album.id}
    @user_sess.assert_not_found
    @photo1.verify
    @album.unverify
    @user_sess.put "/guild_photos/update_multiple", {:photos => {@photo1.id => {:notation => 'n'}}, :album_id => 'invalid'}
    @user_sess.assert_not_found
    @album.verify

    @user_sess.put "/guild_photos/update_multiple", {:photos => {@photo1.id => {:notation => 'photo1'}, @photo2.id => {:notation => 'photo2'}}, :cover_id => @photo2.id, :album_id => @album.id}
    @user_sess.assert_redirected_to guild_album_url(@album)
    @photo1.reload and @photo2.reload and @album.reload
    assert_equal @album.cover, @photo2
    assert_equal @photo1.notation, 'photo1'
    assert_equal @photo2.notation, 'photo2'
  end

  test "GET /guild_photos/:id" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'

    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_photos/#{@photo.id}"
      sess.assert_template "user/guilds/photos/show"
    end

    @photo.unverify 
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_photos/#{@photo.id}"
      sess.assert_not_found
    end
    @photo.verify

    @album.unverify
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guild_photos/#{@photo.id}"
      sess.assert_not_found
    end
    @album.verify
  end

  test "DELETE /guild_photos/:id" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guild_photos/#{@photo.id}"
      sess.assert_not_found
    end

    @user_sess.delete "/guild_photos/invalid"
    @user_sess.assert_not_found

    @photo.unverify 
    @user_sess.delete "/guild_photos/#{@photo.id}"
    @user_sess.assert_not_found
    @photo.verify

    @album.unverify
    @user_sess.delete "/guild_photos/#{@photo.id}"
    @user_sess.assert_not_found
    @album.verify

    assert_difference "@album.reload.photos.count", -1 do
      @user_sess.delete "/guild_photos/#{@photo.id}"
    end
  end

end
