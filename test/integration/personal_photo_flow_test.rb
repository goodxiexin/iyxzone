require 'test_helper'

#
# TODO: verify/unverify
#

class PersonalPhotoFlowTest < ActionController::IntegrationTest

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
  
  test "GET /personal_albums" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    sleep 1
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    sleep 1
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    sleep 1
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
  
    @user_sess.get "/personal_albums", {:uid => @user.id}
    @user_sess.assert_template "user/albums/index"
    assert_equal @user_sess.assigns(:albums), [@album4, @album3, @album2, @album1, @album]

    @user_sess.get "/personal_albums", {:uid => 'invalid'}
    @user_sess.assert_template "errors/404"

    @album3.unverify
    @user_sess.get "/personal_albums", {:uid => @user.id}
    @user_sess.assert_template "user/albums/index"
    assert_equal @user_sess.assigns(:albums), [@album4, @album2, @album1, @album]
    @album3.verify

    @friend_sess.get "/personal_albums", {:uid => @user.id}
    @friend_sess.assert_template "user/albums/index"
    assert_equal @friend_sess.assigns(:albums), [@album3, @album2, @album1, @album]
    
    @same_game_user_sess.get "/personal_albums", {:uid => @user.id}
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/personal_albums", {:uid => @user.id}
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @fan_sess.get "/personal_albums", {:uid => @user.id}
    @fan_sess.assert_template "user/albums/index"
    assert_equal @fan_sess.assigns(:albums), [@album3, @album2, @album1, @album]

    @idol_sess.get "/personal_albums", {:uid => @user.id}
    @idol_sess.assert_template "user/albums/index"
    assert_equal @idol_sess.assigns(:albums), [@album3, @album2, @album1, @album]
  end

  test "GET /personal_albums/friends" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    sleep 1
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    sleep 1
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    sleep 1
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER

    @friend_sess.get "/personal_albums/friends"
    @friend_sess.assert_template "user/albums/friends"
    assert_equal @friend_sess.assigns(:albums), [@album3, @album2, @album1]
  
    @album2.unverify

    @friend_sess.get "/personal_albums/friends"
    @friend_sess.assert_template "user/albums/friends"
    assert_equal @friend_sess.assigns(:albums), [@album3, @album1]
  end

  test "GET /personal_albums/:id" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    sleep 1
    @photo2 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'

    @user_sess.get "/personal_albums/invalid"
    @user_sess.assert_template "errors/404"
   
    @user_sess.get "/personal_albums/#{@album1.id}"
    @user_sess.assert_template "user/albums/show"
    assert_equal @user_sess.assigns(:album), @album1
    assert_equal @user_sess.assigns(:photos), [@photo2, @photo1]
    @user_sess.get "/personal_albums/#{@album2.id}"
    @user_sess.assert_template "user/albums/show"
    assert_equal @user_sess.assigns(:album), @album2
    @user_sess.get "/personal_albums/#{@album3.id}"
    @user_sess.assert_template "user/albums/show"
    assert_equal @user_sess.assigns(:album), @album3
    @user_sess.get "/personal_albums/#{@album4.id}"
    @user_sess.assert_template "user/albums/show"
    assert_equal @user_sess.assigns(:album), @album4

    @photo2.unverify

    [@friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/personal_albums/#{@album1.id}"
      sess.assert_template "user/albums/show"
      assert_equal sess.assigns(:album), @album1
      assert_equal sess.assigns(:photos), [@photo1]
      sess.get "/personal_albums/#{@album2.id}"
      sess.assert_template "user/albums/show"
      assert_equal sess.assigns(:album), @album2
      sess.get "/personal_albums/#{@album3.id}"
      sess.assert_template "user/albums/show"
      assert_equal sess.assigns(:album), @album3
      sess.get "/personal_albums/#{@album4.id}"
      sess.assert_template "errors/404"
    end

    @photo2.verify

    @same_game_user_sess.get "/personal_albums/#{@album1.id}"
    @same_game_user_sess.assert_template "user/albums/show"
    assert_equal @same_game_user_sess.assigns(:album), @album1
    assert_equal @same_game_user_sess.assigns(:photos), [@photo2, @photo1]
    @same_game_user_sess.get "/personal_albums/#{@album2.id}"
    @same_game_user_sess.assert_template "user/albums/show"
    assert_equal @same_game_user_sess.assigns(:album), @album2
    @same_game_user_sess.get "/personal_albums/#{@album3.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)
    @same_game_user_sess.get "/personal_albums/#{@album4.id}"
    @same_game_user_sess.assert_template "errors/404"

    @stranger_sess.get "/personal_albums/#{@album1.id}"
    @stranger_sess.assert_template "user/albums/show"
    assert_equal @stranger_sess.assigns(:album), @album1
    assert_equal @stranger_sess.assigns(:photos), [@photo2, @photo1]
    @stranger_sess.get "/personal_albums/#{@album2.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
    @stranger_sess.get "/personal_albums/#{@album3.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
    @stranger_sess.get "/personal_albums/#{@album4.id}"
    @stranger_sess.assert_template "errors/404"
  end

  test "POST /personal_albums" do
    @user_sess.get "/personal_albums/new"
    @user_sess.assert_template "user/albums/new"
   
    assert_difference "PersonalAlbum.count" do 
      @user_sess.post "/personal_albums", {:album => {:title => 't', :description => 'd', :game_id => @character.game_id}}
    end
  
    assert_no_difference "PersonalAlbum.count" do 
      @user_sess.post "/personal_albums", {:album => {:title => nil, :description => 'd', :game_id => @character.game_id}}
    end
  end

  test "PUT /personal_albums/:id" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id

    @user_sess.get "/personal_albums/invalid/edit"
    @user_sess.assert_template "errors/404"

    @user_sess.get "/personal_albums/#{@album.id}/edit"
    @user_sess.assert_template "user/albums/edit"

    @friend_sess.get "/personal_albums/#{@album.id}/edit"
    @friend_sess.assert_template "errors/404"

    @user_sess.put "/personal_albums/#{@album.id}", {:album => {:description => 'new'}}
    @album.reload
    assert_equal @album.description, 'new'

    @album.unverify
    @user_sess.put "/personal_albums/#{@album.id}", {:album => {:description => 'new'}}
    @user_sess.assert_template "errors/404"

    @album.verify

    # change privilege
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @user_sess.put "/personal_albums/#{@album.id}", {:album => {:privilege => PrivilegedResource::OWNER}} 
    @photo.reload and @album.reload
    assert_equal @album.privilege, PrivilegedResource::OWNER
    assert_equal @photo.privilege, PrivilegedResource::OWNER
  end
  
  test "DELETE /personal_albums/:id" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @album1.reload and @album2.reload and @user.reload
    assert_equal @user.albums_count1, 3

    @user_sess.delete "/personal_albums/#{@album1.id}"
    @user.reload
    assert_equal @user.albums_count1, 2
    assert !Photo.exists?(@photo1.id)
    assert !Photo.exists?(@photo2.id)

    @user_sess.delete "/personal_albums/#{@album2.id}", {:migration => 1, :migrate_to => @album3.id}
    @photo3.reload and @photo4.reload and @album3.reload
    assert_equal @album3.photos_count, 2
    assert_equal @photo3.album, @album3
    assert_equal @photo4.album, @album3

    @friend_sess.delete "/personal_albums/#{@album3.id}"
    @friend_sess.assert_template "errors/404"

    @user_sess.delete "/personal_albums/invalid"
    @user_sess.assert_template "errors/404"

    @album3.unverify

    @user_sess.delete "/personal_albums/#{@album3.id}"
    @user_sess.assert_template "errors/404"
  end
  
  test "PUT /personal_photos/:id" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'

    @user_sess.get "/personal_photos/invalid/edit"
    @user_sess.assert_template "errors/404"

    @friend_sess.get "/personal_photos/#{@photo1.id}/edit"
    @friend_sess.assert_template "errors/404"

    @user_sess.get "/personal_photos/#{@photo1.id}/edit"
    @user_sess.assert_template "user/photos/edit"
    assert_equal @user_sess.assigns(:photo), @photo1

    # change description
    @user_sess.put "/personal_photos/#{@photo1.id}", {:photo => {:notation => 'new'}}
    @photo1.reload
    assert_equal @photo1.notation, 'new'

    # set cover
    @user_sess.put "/personal_photos/#{@photo2.id}", {:photo => {:is_cover => 1}}
    @photo2.reload and @album2.reload
    assert_equal @album2.cover, @photo2

    # unset cover
    @user_sess.put "/personal_photos/#{@photo2.id}", {:photo => {:is_cover => 0}}
    @photo2.reload and @album2.reload
    assert_nil @album2.cover 
 
    # move photo
    @user_sess.put "/personal_photos/#{@photo2.id}", {:photo => {:album_id => @album1.id}}
    @photo2.reload and @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 2
    assert_equal @album2.photos_count, 0
    assert_nil @album2.cover
    assert_nil @album1.cover

    # move photo and set cover
    @user_sess.put "/personal_photos/#{@photo1.id}", {:photo => {:album_id => @album2.id, :is_cover => 1}}
    @photo1.reload and @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 1
    assert_equal @album2.photos_count, 1
    assert_equal @album2.cover, @photo1
    assert_nil @album1.cover

    @user_sess.put "/personal_photos/#{@photo2.id}", {:photo => {:album_id => @album2.id, :is_cover => 0}}
    @photo2.reload and @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 0
    assert_equal @album2.photos_count, 2
    assert_equal @album2.cover, @photo1
    assert_nil @album1.cover
  
    # move back photo
    @user_sess.put "/personal_photos/#{@photo1.id}", {:photo => {:album_id => @album1.id, :is_cover => 1}}
    @photo1.reload and @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 1
    assert_equal @album2.photos_count, 1
    assert_equal @album1.cover, @photo1
    assert_nil @album2.cover
  end
  
  test "DELETE /personal_photos/:id" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'

    @user_sess.delete "/personal_photos/invalid"
    @user_sess.assert_template "errors/404"
  
    @friend_sess.delete "/personal_photos/#{@photo1.id}"
    @friend_sess.assert_template "errors/404"

    @user_sess.delete "/personal_photos/#{@photo1.id}"
    @album1.reload
    assert_equal @album1.photos_count, 0 
  
    @photo2.unverify
    @user_sess.delete "/personal_photos/#{@photo1.id}"
    @user_sess.assert_template "errors/404"
    @album2.reload
    assert_equal @album2.photos_count, 0     
  end
  
  test "POST /personal_photos" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id

    @user_sess.get "/personal_photos/new", {:album_id => 'invalid'}
    @user_sess.assert_template "errors/404"

    @friend_sess.get "/personal_photos/new", {:album_id => @album.id}
    @friend_sess.assert_template "errors/404"

    @user_sess.get "/personal_photos/new", {:album_id => @album.id}
    @user_sess.assert_template "user/photos/new"
    assert_equal @user_sess.assigns(:album), @album

    @friend_sess.post "/personal_photos", {:album_id => @album.id, :Filedata => image_data}
    @friend_sess.assert_template "errors/404"

    @user_sess.post "/personal_photos", {:album_id => 'invalid', :Filedata => image_data}
    @user_sess.assert_template "errors/404"

    @user_sess.post "/personal_photos", {:album_id => @album.id, :Filedata => image_data}
    @album.reload
    assert_equal @album.photos_count, 1
    @photo1 = @user_sess.assigns(:photo)

    @user_sess.post "/personal_photos", {:album_id => @album.id, :Filedata => image_data}
    @album.reload
    assert_equal @album.photos_count, 2
    @photo2 = @user_sess.assigns(:photo)

    @friend.reload and @fan.reload and @idol.reload
    assert !@friend.recv_feed?(@album) 
    assert !@fan.recv_feed?(@album) 
    assert !@idol.recv_feed?(@album) 

    @user_sess.post "/personal_photos/record_upload", {:album_id => @album.id, :ids => []}
    @friend.reload and @fan.reload and @idol.reload
    assert !@friend.recv_feed?(@album) 
    assert !@fan.recv_feed?(@album) 
    assert !@idol.recv_feed?(@album) 

    @user_sess.post "/personal_photos/record_upload", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id]}
    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album) 
    assert @fan.recv_feed?(@album) 
    assert !@idol.recv_feed?(@album) 
    
    @user_sess.post "/personal_photos", {:album_id => @album.id, :Filedata => image_data}
    @photo3 = @user_sess.assigns(:photo)
    @user_sess.post "/personal_photos/record_upload", {:album_id => @album.id, :ids => [@photo3.id]}
    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album) 
    assert @fan.recv_feed?(@album) 
    assert !@idol.recv_feed?(@album) 
  end

  test "edit multiple and update multiple" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    sleep 1
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    sleep 1
    @photo3 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'

    @user_sess.get "/personal_photos/edit_multiple", {:album_id => @album.id, :ids => ['invalid', @photo2.id, @photo3.id]}
    @user_sess.assert_template "errors/404"

    @friend_sess.get "/personal_photos/edit_multiple", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id, @photo3.id]}
    @friend_sess.assert_template "errors/404"

    @user_sess.get "/personal_photos/edit_multiple", {:album_id => @album.id, :ids => [@photo1.id, @photo2.id, @photo3.id]}
    @user_sess.assert_template "user/photos/edit_multiple"
    assert_equal @user_sess.assigns(:photos), [@photo3, @photo2, @photo1]

    @user_sess.put "/personal_photos/update_multiple", {:album_id => 'invalid', :photos => {@photo1.id => {:notation => 'photo1'}}}
    @user_sess.assert_template "errors/404"

    @friend_sess.put "/personal_photos/update_multiple", {:album_id => @album.id, :photos => {@photo1.id => {:notation => 'photo1'}}}
    @friend_sess.assert_template "errors/404"

    @user_sess.put "/personal_photos/update_multiple", {:album_id => @album.id, :cover_id => @photo2.id, :photos => {@photo1.id => {:notation => 'photo1'}, @photo2.id => {:notation => 'photo2'}, @photo3.id => {:notation => 'photo3'}}}
    @user_sess.assert_redirected_to personal_album_url(@album)
    @photo1.reload and @photo2.reload and @photo3.reload and @album.reload
    assert_equal @photo1.notation, 'photo1'
    assert_equal @photo2.notation, 'photo2'
    assert_equal @photo3.notation, 'photo3'
    assert_equal @album.cover, @photo2

    @photo2.unverify
    @user_sess.put "/personal_photos/update_multiple", {:album_id => @album.id, :cover_id => @photo2.id, :photos => {@photo1.id => {:notation => 'new photo1'}, @photo2.id => {:notation => 'new photo2'}, @photo3.id => {:notation => 'new photo3'}}}
    @user_sess.assert_redirected_to personal_album_url(@album)
    @photo1.reload and @photo2.reload and @photo3.reload and @album.reload
    assert_equal @photo1.notation, 'new photo1'
    assert_equal @photo2.notation, 'photo2'
    assert_equal @photo3.notation, 'new photo3'
    assert_equal @album.cover, @photo2

    @album.unverify
    @user_sess.put "/personal_photos/update_multiple", {:album_id => @album.id, :photos => {@photo1.id => {:notation => 'new photo1'}}}
    @user_sess.assert_template "errors/404"
  end

protected

  def login user
    open_session do |session|
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
