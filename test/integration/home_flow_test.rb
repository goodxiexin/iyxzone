require 'test_helper'

class HomeFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @same_game_user = UserFactory.create
    @stranger = UserFactory.create
    @idol = UserFactory.create_idol
    @profile = @user.profile

    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @same_game_user_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @same_game_user.id})
    @idol_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @idol.id})    
    @game = @user_character.game

    FriendFactory.create @user, @friend
    FanFactory.create @user, @idol

    [@user, @friend, @same_game_user, @stranger, @idol].each {|u| u.reload}
    [@user_character, @friend_character, @same_game_user_character].each {|u| u.reload}
  
    @user_sess = login @user
   end

  test "GET /home" do
    # blog feed and friend tag
    @blog = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    assert @user.reload.recv_feed?(@blog)
    
    # blog tag
    @blog.update_attributes :new_friend_tags => [@user.id]
    @tag = FriendTag.last
    assert @user.reload.recv_notice?(@tag)

    # blog sharing feed
    @blog.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)    

    # blog comment notice
    @comment = @blog.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # video feed
    @video = VideoFactory.create :poster_id => @idol.id, :game_id => @game.id
    assert @user.reload.recv_feed?(@video)
 
    # video tag
    @video.update_attributes :new_friend_tags => [@user.id]
    @tag = FriendTag.last
    assert @user.reload.recv_notice?(@tag)

    # video sharing feed
    @video.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # video comment notice
    @comment = @video.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # status feed
    @status = StatusFactory.create :poster_id => @friend.id
    assert @user.reload.recv_feed?(@status)

    # status comment
    @comment = @status.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # personal album
    @album = PersonalAlbumFactory.create :owner_id => @friend.id
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @album.record_upload @friend, [@photo]
    assert @user.reload.recv_feed?(@album)

    # share album
    @album.share_by @friend
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # album comment
    @comment = @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # photo tag
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :tagged_user_id => @user.id, :poster_id => @friend.id
    assert @user.reload.recv_notice?(@tag)

    # photo comment
    @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)    

    # change avatar
    @avatar = PhotoFactory.create :album_id => @friend.avatar_album.id, :type => 'Avatar'
    @album.set_cover @avatar
    assert @user.reload.recv_feed?(@avatar)  

    # avatar comment
    @comment = @avatar.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # tag avatar
    @tag = PhotoTagFactory.create :photo_id => @avatar.id, :tagged_user_id => @user.id, :poster_id => @friend.id
    assert @user.reload.recv_notice?(@tag)

    # avatar sharing
    @avatar.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # poll
    @poll = Poll.create :poster_id => @friend.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    assert @user.reload.recv_feed?(@poll)

    # comment poll
    @comment = @poll.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # share poll
    @poll.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # vote
    @vote = @poll.votes.create :answer_ids => [@poll.answers.first.id], :voter_id => @friend.id
    assert @user.reload.recv_feed?(@vote)

    # event feed
    @event = EventFactory.create :character_id => @idol_character.id
    assert @user.reload.recv_feed?(@event)
    @request = @event.requests.create :participant_id => @friend.id, :character_id => @friend_character.id
    @request.accept_request
    assert @user.reload.recv_feed?(@request)
   
    @event.confirmed_participations.create :participant_id => @user.id, :character_id => @user_character.id
 
    # event comment notice
    @comment = @event.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a' 
    assert @user.reload.recv_notice?(@comment)

    # share event album
    @album = @event.album
    @album.share_by @friend
    @sharing = Sharing.last
    assert @user.recv_feed?(@sharing)

    # comment event album
    @comment = @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # event photo 
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @album.record_upload @idol, [@photo]
    assert @user.reload.recv_feed?(@album)

    # photo tag
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :tagged_user_id => @user.id, :poster_id => @friend.id
    assert @user.reload.recv_notice?(@tag)

    # photo comment
    @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # share photo
    @photo.share_by @friend
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # guild feed
    @guild = GuildFactory.create :character_id => @idol_character.id
    assert @user.reload.recv_feed?(@guild)
    @request = @guild.requests.create :user_id => @friend.id, :character_id => @friend_character.id
    @request.accept_request
    assert @user.reload.recv_feed?(@request)
   
    @guild.member_memberships.create :user_id => @user.id, :character_id => @user_character.id
 
    # guild comment notice
    @comment = @guild.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a' 
    assert @user.reload.recv_notice?(@comment)

    # share guild album
    @album = @guild.album
    @album.share_by @friend
    @sharing = Sharing.last
    assert @user.recv_feed?(@sharing)

    # comment guild album
    @comment = @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # guild photo 
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    @album.record_upload @idol, [@photo]
    assert @user.reload.recv_feed?(@album)

    # photo tag
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :tagged_user_id => @user.id, :poster_id => @friend.id
    assert @user.reload.recv_notice?(@tag)

    # photo comment
    @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # share photo
    @photo.share_by @friend
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # reply topic
    @forum = @guild.forum
    @topic = TopicFactory.create :poster_id => @friend.id, :forum_id => @forum.id
    @post = PostFactory.create :topic_id => @topic.id, :poster_id => @friend.id, :recipient_id => @user.id
    assert @user.reload.recv_notice?(@post)

    # share topic
    @topic.share_by @friend
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # news comment
    # TODO

    # news sharing
    # TODO
  
    # comment application
    @application = ApplicationFactory.create
    @comment = @application.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # reply profile wall messages
    @comment = @user.profile.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # friends
    @request = Friendship.create :user_id => @same_game_user.id, :friend_id => @friend.id, :status => Friendship::Request
    @request.accept
    assert @user.reload.recv_feed?(@request) 

    # game character
    @another_friend_character = GameCharacterFactory.create :user_id => @friend.id
    assert @user.reload.recv_feed?(@another_friend_character)
    @friend_character.update_attributes :playing => 0
    assert @user.reload.recv_feed?(@friend_character)

    # share game
    @game.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # comment sharing
    @comment = @sharing.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @user.reload.recv_notice?(@comment)

    # share link
    @link = Link.create :url => 'www.baidu.com'
    @link.share_by @friend, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)

    # change profile
    @friend.profile.update_attributes :qq => '12345678'
    assert @user.reload.recv_feed?(@friend.profile)

    # share profile
    @friend.profile.share_by @idol, 'r', 't'
    @sharing = Sharing.last
    assert @user.reload.recv_feed?(@sharing)
  
    @feed_deliveries = @user.feed_deliveries

    # create friend suggestions
    @user.create_friend_suggestions

    # create viewings
    @user.profile.viewed_by @friend
    @user.profile.viewed_by @same_game_user

    # create invitations and requests
    @user_character2 = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @user.id})
    @user_event = EventFactory.create :character_id => @user_character2.id
    @user_guild = GuildFactory.create :character_id => @user_character2.id
    @event.invitations.create :participant_id => @user.id, :character_id => @user_character2.id
    @user_event.requests.create :participant_id => @friend.id, :character_id => @friend_character.id
    @guild.invitations.create :user_id => @user.id, :character_id => @user_character2.id
    @user_guild.requests.create :user_id => @friend.id, :character_id => @friend_character.id
    @poll.invitations.create :user_id => @user.id
    @user.friend_requests.create :user_id => @same_game_user.id

    # check feeds
    @user_sess.get "/home"
    @user_sess.assert_template "user/home/show"
    assert_equal @user_sess.assigns(:feed_deliveries), @feed_deliveries[0..9]   
    @user_sess.get "/home/feeds"
    assert_equal @user_sess.assigns(:feed_deliveries), @feed_deliveries[0..9]
    cnt = @feed_deliveries.count / 10
    cnt.times do |i|
      @user_sess.get "/home/more_feeds", {:idx => i}
      assert_equal @user_sess.assigns(:feed_deliveries), @feed_deliveries[(10*(i+1))..(10*(i+2) - 1)]
    end

    # more feeds
    ['all', 'status', 'blog', 'all_album_related', 'video', 'sharing'].each_with_index do |type, i|
      feed_deliveries = eval("@user.#{type}_feed_deliveries")
      @user_sess.get "/home/feeds", {:type => i}
      assert_equal @user_sess.assigns(:feed_deliveries), feed_deliveries[0..9]
      cnt = feed_deliveries.count / 10
      cnt.times do |idx|
        @user_sess.get "/home/more_feeds", {:type => i, :idx => idx}
        assert_equal @user_sess.assigns(:feed_deliveries), feed_deliveries[(10*(idx+1))..(10*(idx+2) - 1)]
      end
    end
  end


end
