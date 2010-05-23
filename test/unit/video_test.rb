require 'test_helper'

class VideoTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    @profile = @user.profile
  
    # create 4 friends
    @friend1 = UserFactory.create
    @friend2 = UserFactory.create
    @friend3 = UserFactory.create
    @friend4 = UserFactory.create
    FriendFactory.create @user, @friend1
    FriendFactory.create @user, @friend2
    FriendFactory.create @user, @friend3
    FriendFactory.create @user, @friend4
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
    
    # create 2 guilds
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member    
  end

  #
  # case1
  # 创建视频，然后更新，然后删除
  #
  test "case1" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html'
    assert !@video.nil?

    @video.update_attributes(:title => '')
    assert @video.errors.on(:title)

    @video.update_attributes(:description => 'new')
    @video.reload
    assert_equal @video.description, 'new'

    @video.update_attributes(:video_url => 'http://v.youku.com/v_show/id_XMTY0NTgzMzQw.html')
    assert @video.errors.on(:video_url)

    @video.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @video.reload
    assert_equal @video.privilege, PrivilegedResource::FRIEND

    @video.destroy
    assert @video.nil?
  end

  #
  # case2
  # 测试计数器
  #
  test "case2" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html'
    @user.reload
    assert_equal @user.videos_count1, 1

    @video.update_attributes(:privilege => PrivilegedResource::FRIEND_OR_SAME_GAME)
    @user.reload
    assert_equal @user.videos_count1, 0
    assert_equal @user.videos_count2, 1
 
    @video.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @user.reload
    assert_equal @user.videos_count2, 0
    assert_equal @user.videos_count3, 1

    @video.update_attributes(:privilege => PrivilegedResource::OWNER)
    @user.reload
    assert_equal @user.videos_count3, 0
    assert_equal @user.videos_count4, 1

    @video.destroy
    @user.reload
    assert_equal @user.videos_count4, 0
  end 

  #
  # case 3
  # video tags, relative users
  #
  test "case3" do
    # acts_as_friend_taggable在blog里面已经测过了
  end

  #
  # case 4
  # dig video
  #
  test "case4" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::PUBLIC
    @video.reload
    assert_equal @video.digs_count, 0
 
    assert @video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1
    assert @video.digged_by?(@user)
    assert !@video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1

    assert @video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2
    assert @video.digged_by?(@friend1)
    assert !@video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2

    assert @video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 3
    assert @video.digged_by?(@same_game_user)
    assert !@video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 3

    assert @video.dug_by(@stranger)
    @video.reload
    assert_equal @video.digs_count, 4
    assert @video.digged_by?(@stranger)
    assert !@video.dug_by(@stranger)
    @video.reload
    assert_equal @video.digs_count, 4

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @video.reload
    assert_equal @video.digs_count, 0
 
    assert @video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1
    assert @video.digged_by?(@user)
    assert !@video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1

    assert @video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2
    assert @video.digged_by?(@friend1)
    assert !@video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2

    assert @video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 3
    assert @video.digged_by?(@same_game_user)
    assert !@video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 3

    assert !@video.dug_by(@stranger)
    @video.reload
    assert_equal @video.digs_count, 3
    assert !@video.digged_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND
    @video.reload
    assert_equal @video.digs_count, 0
 
    assert @video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1
    assert @video.digged_by?(@user)
    assert !@video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1

    assert @video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2
    assert @video.digged_by?(@friend1)
    assert !@video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 2

    assert !@video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 2
    assert !@video.digged_by?(@same_game_user)

    assert !@video.dug_by(@stranger)
    @video.reload
    assert_equal @video.digs_count, 2
    assert !@video.digged_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::OWNER
    @video.reload
    assert_equal @video.digs_count, 0
 
    assert @video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1
    assert @video.digged_by?(@user)
    assert !@video.dug_by(@user)
    @video.reload
    assert_equal @video.digs_count, 1

    assert !@video.dug_by(@friend1)
    @video.reload
    assert_equal @video.digs_count, 1
    assert !@video.digged_by?(@friend1)

    assert !@video.dug_by(@same_game_user)
    @video.reload
    assert_equal @video.digs_count, 1
    assert !@video.digged_by?(@same_game_user)

    assert !@video.dug_by(@stranger)
    @video.reload
    assert_equal @video.digs_count, 1
    assert !@video.digged_by?(@stranger)
  end

  #
  # case5
  # video feeds
  #
  test "case5" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html'
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)

    @video.update_attributes(:privilege => PrivilegedResource::OWNER)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::OWNER
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
  
    @video.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
  end

  #
  # case6
  # share video
  #
  test "case6" do
    t = 'share title'
    r = 'share reason'

    @video1 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html'

    assert @video1.share_by(@user, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 1
    assert !@video1.share_by(@user, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 1

    assert @video1.share_by(@friend1, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 2
    assert !@video1.share_by(@friend1, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 2

    assert @video1.share_by(@same_game_user, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 3
    assert !@video1.share_by(@same_game_user, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 3

    assert @video1.share_by(@stranger, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 4
    assert !@video1.share_by(@stranger, t, r)
    @video1.reload
    assert_equal @video1.sharings_count, 4

    assert_equal @video1.first_sharer, @user

    @video2 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    assert @video2.share_by(@user, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 1
    assert !@video2.share_by(@user, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 1

    assert @video2.share_by(@friend1, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 2
    assert !@video2.share_by(@friend1, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 2

    assert @video2.share_by(@same_game_user, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 3
    assert !@video2.share_by(@same_game_user, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 3

    assert !@video2.share_by(@stranger, t, r)
    @video2.reload
    assert_equal @video2.sharings_count, 3

    assert_equal @video2.first_sharer, @user

    @video3 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND

    assert @video3.share_by(@user, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 1
    assert !@video3.share_by(@user, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 1

    assert @video3.share_by(@friend1, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 2
    assert !@video3.share_by(@friend1, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 2

    assert !@video3.share_by(@same_game_user, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 2

    assert !@video3.share_by(@stranger, t, r)
    @video3.reload
    assert_equal @video3.sharings_count, 2

    assert_equal @video3.first_sharer, @user

    @video4 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::OWNER

    assert @video4.share_by(@user, t, r)
    @video4.reload
    assert_equal @video4.sharings_count, 1
    assert !@video4.share_by(@user, t, r)
    @video4.reload
    assert_equal @video4.sharings_count, 1

    assert !@video4.share_by(@friend1, t, r)
    @video4.reload
    assert_equal @video4.sharings_count, 1

    assert !@video4.share_by(@same_game_user, t, r)
    @video4.reload
    assert_equal @video4.sharings_count, 1

    assert !@video4.share_by(@stranger, t, r)
    @video4.reload
    assert_equal @video4.sharings_count, 1

    assert_equal @video3.first_sharer, @user
  end

  #
  # case 7
  # sensitive video
  #
  test "case7" do
    @sensitive = '政府'

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html'
    @video.reload and @user.reload
    assert @video.accepted?
    assert_equal @user.videos_count, 1

    @video.update_attributes(:description => @sensitive)
    @video.reload and @user.reload
    assert @video.unverified?
    assert_equal @user.videos_count, 1
    
    @video.unverify
    @video.reload and @user.reload
    assert @video.rejected?
    assert_equal @user.videos_count, 0

    @video.destroy
    @user.reload
    assert_equal @user.videos_count, 0

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :title => @sensitive
    @video.reload and @user.reload
    assert @video.unverified?
    assert_equal @user.videos_count, 1

    @video.verify
    @video.reload and @user.reload
    assert @video.accepted?
    assert_equal @user.videos_count, 1
  end

  #
  # case 8
  # comment video
  #
  test "case8" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::PUBLIC
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 2
    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 3
    @comment = @video.comments.create :poster_id => @stranger.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 4

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 2
    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 3
    @comment = @video.comments.create :poster_id => @stranger.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 3

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::FRIEND
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 2
    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 2
    @comment = @video.comments.create :poster_id => @stranger.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 2

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::OWNER
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert !@comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 1
    @comment = @video.comments.create :poster_id => @stranger.id, :content => 'comment', :recipient_id => @user.id
    @video.reload
    assert @comment.id.nil?
    assert_equal @video.comments_count, 1
  end

  #
  # case9
  # relative videos
  #
  test "case9" do
    # acts_as_privileged_resource在blog_test.rb里已经测过了
  end

  #
  # case10
  # 各种类型的url
  #
  test "case10" do
    # YOUKU
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTYwMDU2NTI4.html', :privilege => PrivilegedResource::PUBLIC
  end

end
