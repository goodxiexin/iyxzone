require 'test_helper'

class NoticeFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @game = @user_character.game
    FriendFactory.create @user, @friend

    # create some notices
    # blog tag and comment
    @blog = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id, :new_friend_tags => [@user.id]
    @n1 = Notice.last
    @blog.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n2 = Notice.last
    @blog.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n3 = Notice.last

    # application comment
    @application = ApplicationFactory.create
    @application.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n4 = Notice.last

    # video tag and comment
    @video = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :new_friend_tags => [@user.id]
    @n5 = Notice.last
    @video.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n6 = Notice.last
    @video.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n7 = Notice.last

    # status comment
    @status = StatusFactory.create :poster_id => @user.id
    @status.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n8 = Notice.last

    # poll comment
    @poll = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    @poll.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n9 = Notice.last

    # event comment
    @event = EventFactory.create :character_id => @user_character.id
    @event.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n10 = Notice.last

    # guild comment
    @guild = GuildFactory.create :character_id => @user_character.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id
    @guild.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n11 = Notice.last

    # game comment@blog.comments.create
    @game.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n12 = Notice.last

    # sharing comment
    @game.share_by @user, 'r', 't'
    @sharing = Sharing.last
    @sharing.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n13 = Notice.last

    # profile comment
    @user.profile.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n14 = Notice.last

    # news comment
    # TODO

    # post comment
    @forum = @guild.forum
    @topic = TopicFactory.create :forum_id => @forum.id, :poster_id => @user.id
    @post = PostFactory.create :topic_id => @topic.id, :recipient_id => @user.id, :poster_id => @friend.id
    @n15 = Notice.last

    # photo comments
    # personal album
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n16 = Notice.last    
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n17 = Notice.last    
 
    @avatar_album = @user.avatar_album
    @avatar_album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n18 = Notice.last
    @avatar = PhotoFactory.create :album_id => @avatar_album.id, :type => 'Avatar'
    @avatar.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n19 = Notice.last

    @event_album = @event.album
    @event_album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n20 = Notice.last
    @event_photo = PhotoFactory.create :album_id => @event_album.id, :type => 'EventPhoto'
    @event_photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n21 = Notice.last

    @guild_album = @guild.album
    @guild_album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n22 = Notice.last
    @guild_photo = PhotoFactory.create :album_id => @guild_album.id, :type => 'GuildPhoto'
    @guild_photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @n23 = Notice.last

    # photo tags
    PhotoTagFactory.create :poster_id => @friend.id, :tagged_user_id => @user.id, :photo_id => @photo.id
    @n24 = Notice.last
    PhotoTagFactory.create :poster_id => @friend.id, :tagged_user_id => @user.id, :photo_id => @avatar.id
    @n25 = Notice.last
    PhotoTagFactory.create :poster_id => @friend.id, :tagged_user_id => @user.id, :photo_id => @event_photo.id
    @n26 = Notice.last
    PhotoTagFactory.create :poster_id => @friend.id, :tagged_user_id => @user.id, :photo_id => @guild_photo.id
    @n27 = Notice.last

    @user_sess = login @user
  end

  test "get notices" do
    @notices = @user.notices.unread
    
    @user_sess.get "/notices/first_ten"
    @user_sess.assert_template "user/notices/_notices"
    assert_equal @user_sess.assigns(:notices), @notices[0..9]

    @user_sess.put "/notices/invalid/read"
    @user_sess.assert_not_found

    # read multiple
    assert_difference "@user.reload.unread_notices_count", -2 do
      @user_sess.put "/notices/#{@n2.id}/read"
    end
    @user_sess.assert_template "user/notices/_notices"
    assert @n3.reload.read
 
    # read single
    assert_difference "@user.reload.unread_notices_count", -1 do
      @user_sess.put "/notices/#{@n6.id}/read", {:single => 1}
    end
    @user_sess.assert_template "user/notices/_notices"
    assert !@n7.reload.read

    @notices = @user.notices.unread

    # read one by one
    @notices.each_with_index do |n, i|
      assert_difference "@user.reload.unread_notices_count", -1 do
        @user_sess.put "/notices/#{n.id}/read"
      end
      @user_sess.assert_template "user/notices/_notices"
      assert_equal @user_sess.assigns(:notices), @user.notices.unread[0..9]
      assert n.reload.read      
    end 
  end

end
