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
    
  end
  
  #
  # case1
  # 创建视频，然后更新，然后删除
  #
  test "case1" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    assert !@video.nil?

# TODO
# 为啥简单的更新不行呢
=begin
    @video.update_attributes(:title => '')
    assert_not_nil @video.errors.on(:title)

    @video.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @video.reload
    assert_equal @video.privilege, PrivilegedResource::FRIEND
=end
    @video.destroy
  end

  #
  # case2
  # 测试计数器
  #
  test "case2" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
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
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert @video.is_diggable_by?(@same_game_user)
    assert @video.is_diggable_by?(@stranger)
  
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert @video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert !@video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert !@video.is_diggable_by?(@friend1)
    assert !@video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)  
  end

  #
  # case5
  # video feeds
  #
  test "case5" do
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member    

    @user.is_idol = true
    @user.save
    @fan = UserFactory.create
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
    assert @fan.recv_feed?(@video)

    @video.update_attributes(:privilege => PrivilegedResource::OWNER)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)
    
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)  

    @video.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
    assert @fan.recv_feed?(@video)

    @video.unverify
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)  

    @video.verify
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
    assert @fan.recv_feed?(@video)
  end

  #
  # case6
  # share video
  #
  test "case6" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert @video.is_shareable_by?(@same_game_user)
    assert @video.is_shareable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert @video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert !@video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @video.is_shareable_by?(@user)
    assert !@video.is_shareable_by?(@friend1)
    assert !@video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)
  end

  #
  # case 7
  # sensitive video
  #
  test "case7" do
    @sensitive = '政府'

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
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

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :title => @sensitive
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
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert @video.is_commentable_by?(@same_game_user)
    assert @video.is_commentable_by?(@stranger)
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @stranger.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert @comment.is_deleteable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert @video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @same_game_user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert !@video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER

    assert @video.is_commentable_by?(@user)
    assert !@video.is_commentable_by?(@friend1)
    assert !@video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    
    @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
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
    youku_single_url = 'http://v.youku.com/v_show/id_XMTY3NDE5Nzg4.html'
    youku_album_url = 'http://v.youku.com/v_playlist/f4397189o1p0.html'
    
    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => youku_single_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    # 无法解析
    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => youku_album_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    # TUDOU
    tudou_single_url = 'http://www.tudou.com/programs/view/Vp7jDPiKHrI/'
    tudou_album_url = 'http://www.tudou.com/playlist/playindex.do?lid=8375220&iid=497five6711&cid=29'
    tudou_album2_url = 'http://www.tudou.com/playlist/playindex.do?lid=8375316'
    tudou_hd_url = 'http://hd.tudou.com/program/23631/'
    
    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => tudou_single_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html
    
    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => tudou_album_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => tudou_album2_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => tudou_hd_url, :title => 't', :description => 'd'
    assert_nil @video.id
    assert_nil @video.embed_html

    # KU6
    ku6_single_url = 'http://v.ku6.com/show/TP4_MH4b4Tv-Cy4R.html'
    ku6_album1_url = 'http://v.ku6.com/special/show_3774439/-3udnB3l3hh5lfN7.html'
    ku6_album2_url = 'http://v.ku6.com/film/show_124553/_B5b887EE3f-1Qs3.html'
    ku6_hd_url =  'http://hd.ku6.com/show/112315.html'
    ku6_yushan_url = 'http://v.ku6.com/film/index_117958.html' 

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => ku6_single_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => ku6_album1_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => ku6_album2_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => ku6_hd_url, :title => 't', :description => 'd'
    assert_nil @video.id
    assert_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => ku6_yushan_url, :title => 't', :description => 'd'
    assert_nil @video.id
    assert_nil @video.embed_html

    # five6
    five6_single_url = 'http://www.56.com/u80/v_NTEwODM5ODE.html'
    five6_album_url = 'http://www.56.com/w96/play_album-aid-8079861_vid-NTEwODYxNDU.html'
    five6_photo_url = 'http://www.56.com/p96/v_ADAdsfsdfsad.html'

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => five6_single_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => five6_album_url, :title => 't', :description => 'd'
    assert_not_nil @video.id
    assert_not_nil @video.embed_html

    @video = Video.create :poster_id => @user.id, :game_id => @game.id, :video_url => five6_photo_url, :title => 't', :description => 'd'
    assert_nil @video.id
    assert_nil @video.embed_html
  end

end
