require 'test_helper'

class AvatarFlowTest < ActionController::IntegrationTest

  def setup
    # create a user with game character
    @user = UserFactory.create_idol
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

    # create friend
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    GameCharacterFactory.create @character.game_info.merge({:user_id => @friend.id})
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    GameCharacterFactory.create @character.game_info.merge({:user_id => @same_game_user.id})

    # create stranger
    @stranger = UserFactory.create

    # create fan and idol
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id

    # login
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @fan_sess = login @fan
    @idol_sess = login @idol

    @album = @user.avatar_album
  end

  test "POST /avatars" do
    @user_sess.get "/avatars/new", {:at => 'profile'}
    @user_sess.assert_template 'user/avatars/photos/new'

    @album.unverify
    @user_sess.get "/avatars/new", {:at => 'profile'}
    @user_sess.assert_not_found

    @album.verify
    @user_sess.post "/avatars", {:at => 'profile', :photo => {:image_data => image_data}}
    @user.reload and @album.reload
    assert_equal @user.avatar, @user_sess.assigns(:photo)
    assert_equal @album.cover, @user_sess.assigns(:photo)

    @album.unverify
    @user_sess.post "/avatars", {:at => 'profile', :photo => {:image_data => image_data}}
    @user_sess.assert_not_found

    @album.verify
    @user_sess.post "/avatars", {:at => 'album', :photo => {:image_data => image_data}}
    @user.reload and @album.reload
    assert_equal @user.avatar, @user_sess.assigns(:photo)
    assert_equal @album.cover, @user_sess.assigns(:photo)
  end

  test "GET /avatar_albums/:id" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    sleep 1
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    @album.set_cover @photo1

    @user_sess.get "/avatar_albums/invalid"
    @user_sess.assert_not_found

    @album.unverify
    @user_sess.get "/avatar_albums/#{@album.id}"
    @user_sess.assert_template "errors/404"

    @album.verify
    @user_sess.get "/avatar_albums/#{@album.id}"
    @user_sess.assert_template "user/avatars/albums/show"
    assert_equal @user_sess.assigns(:photos), [@photo2, @photo1]

    @photo2.unverify
    @user_sess.get "/avatar_albums/#{@album.id}"
    @user_sess.assert_template "user/avatars/albums/show"
    assert_equal @user_sess.assigns(:photos), [@photo1]

    @photo2.verify
    @friend_sess.get "/avatar_albums/#{@album.id}"
    @friend_sess.assert_template "user/avatars/albums/show"
    assert_equal @friend_sess.assigns(:photos), [@photo2, @photo1]

    @fan_sess.get "/avatar_albums/#{@album.id}"
    @fan_sess.assert_template "user/avatars/albums/show"
    assert_equal @fan_sess.assigns(:photos), [@photo2, @photo1]

    @idol_sess.get "/avatar_albums/#{@album.id}"
    @idol_sess.assert_template "user/avatars/albums/show"
    assert_equal @idol_sess.assigns(:photos), [@photo2, @photo1]

    @same_game_user_sess.get "/avatar_albums/#{@album.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/avatar_albums/#{@album.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
  end

  test "PUT /avatar_albums/:id" do
    @user_sess.put "/avatar_albums/invalid", {:album => {:description => 'haha'}}
    @user_sess.assert_not_found

    @album.unverify
    @user_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @user_sess.assert_not_found

    @album.verify
    @user_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @album.reload
    assert_equal @album.description, 'haha'

    @friend_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @friend_sess.assert_not_found

    @same_game_user_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @same_game_user_sess.assert_not_found

    @stranger_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @stranger_sess.assert_not_found

    @fan_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @fan_sess.assert_not_found

    @idol_sess.put "/avatar_albums/#{@album.id}", {:album => {:description => 'haha'}}
    @idol_sess.assert_not_found    
  end

  test "GET /avatars/:id" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'

    @user_sess.get "/avatars/invalid"
    @user_sess.assert_not_found

    @photo.unverify
    @user_sess.get "/avatars/#{@photo.id}"
    @user_sess.assert_not_found

    @photo.verify
    @user_sess.get "/avatars/#{@photo.id}"
    @user_sess.assert_template 'user/avatars/photos/show'
    assert_equal @user_sess.assigns(:photo), @photo

    @friend_sess.get "/avatars/#{@photo.id}"
    @friend_sess.assert_template 'user/avatars/photos/show'
    assert_equal @friend_sess.assigns(:photo), @photo

    @same_game_user_sess.get "/avatars/#{@photo.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/avatars/#{@photo.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @fan_sess.get "/avatars/#{@photo.id}"
    @fan_sess.assert_template 'user/avatars/photos/show'
    assert_equal @fan_sess.assigns(:photo), @photo

    @idol_sess.get "/avatars/#{@photo.id}"
    @idol_sess.assert_template 'user/avatars/photos/show'
    assert_equal @idol_sess.assigns(:photo), @photo
  end

  test "PUT /avatars/:id" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    @cover = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    @album.set_cover @cover    

    # edit
    @photo.unverify
    @user_sess.get "/avatars/#{@photo.id}/edit"
    @user_sess.assert_template "errors/404"

    @photo.verify
    @user_sess.get "/avatars/#{@photo.id}/edit"
    @user_sess.assert_template "user/avatars/photos/edit"

    @user_sess.get "/avatars/invalid/edit"
    @user_sess.assert_template "errors/404"

    @friend_sess.get "/avatars/#{@photo.id}/edit"
    @friend_sess.assert_not_found

    @same_game_user_sess.get "/avatars/#{@photo.id}/edit"
    @same_game_user_sess.assert_not_found

    @stranger_sess.get "/avatars/#{@photo.id}/edit"
    @stranger_sess.assert_not_found

    @fan_sess.get "/avatars/#{@photo.id}/edit"
    @fan_sess.assert_not_found

    @idol_sess.get "/avatars/#{@photo.id}/edit"
    @idol_sess.assert_not_found
    
    # update
    @photo.unverify
    @user_sess.put "/avatars/#{@photo.id}", {:photo => {:notation => 'haha'}}
    @user_sess.assert_template "errors/404"

    @photo.verify
    @user_sess.put "/avatars/invalid", {:photo => {:notation => 'haha'}}
    @user_sess.assert_template "errors/404"

    @user_sess.put "/avatars/#{@photo.id}", {:photo => {:notation => 'haha'}}
    @photo.reload
    assert_equal @photo.notation, 'haha'

    # set cover
    @user_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @album.reload and @user.reload
    assert_equal @album.cover, @photo
    assert_equal @user.avatar, @photo 
 
    @friend_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @friend_sess.assert_not_found

    @same_game_user_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @same_game_user_sess.assert_not_found

    @stranger_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @stranger_sess.assert_not_found

    @fan_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @fan_sess.assert_not_found

    @idol_sess.put "/avatars/#{@photo.id}", {:photo => {:is_cover => 1}}
    @idol_sess.assert_not_found
  end

  test "DELETE /avatars/:id" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'

    @photo.unverify
    @user_sess.delete "/avatars/#{@photo.id}"
    @user_sess.assert_template "errors/404"

    @photo.verify
    @user_sess.delete "/avatars/invalid"
    @user_sess.assert_template "errors/404"

    @friend_sess.delete "/avatars/#{@photo.id}"
    @friend_sess.assert_template "errors/404"

    @same_game_user_sess.delete "/avatars/#{@photo.id}"
    @same_game_user_sess.assert_template "errors/404"
 
    @stranger_sess.delete "/avatars/#{@photo.id}"
    @stranger_sess.assert_template "errors/404"

    @fan_sess.delete "/avatars/#{@photo.id}"
    @fan_sess.assert_template "errors/404"

    @idol_sess.delete "/avatars/#{@photo.id}"
    @idol_sess.assert_template "errors/404"
  
    @user_sess.delete "/avatars/#{@photo.id}"
    @album.reload
    assert @album.photos.blank?
  end
  
end
