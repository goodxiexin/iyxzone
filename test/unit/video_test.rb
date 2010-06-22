require 'test_helper'

class VideoTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create_idol
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
    @character2 = GameCharacterFactory.create @character.game_info.merge({:user_id => @same_game_user.id})

    # create fan and idol
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id

    [@user, @friend1, @friend2, @friend3, @friend4, @fan, @idol].each {|f| f.reload}
  end
  
  test "create/update/destroy video" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    assert !@video.nil?
=begin
# TODO
# 为啥简单的更新不行呢
    @video.update_attributes(:title => '')
    assert_not_nil @video.errors.on(:title)

    @video.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @video.reload
    assert_equal @video.privilege, PrivilegedResource::FRIEND
=end
    @video.destroy
  end

  test "counter" do
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

  test "friend tag" do
    assert_difference "Notice.count" do
      VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    assert_difference "Notice.count" do
      VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    assert_difference "Notice.count" do
      VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    assert_no_difference "Notice.count" do
      VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert !@friend1.recv_notice?(@tag)
  end
  
  test "dig video" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert @video.is_diggable_by?(@same_game_user)
    assert @video.is_diggable_by?(@stranger)
    assert @video.is_diggable_by?(@fan)
    assert @video.is_diggable_by?(@idol) 
 
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert @video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)
    assert @video.is_diggable_by?(@fan)
    assert @video.is_diggable_by?(@idol) 

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert @video.is_diggable_by?(@friend1)
    assert !@video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)
    assert @video.is_diggable_by?(@fan)
    assert @video.is_diggable_by?(@idol) 

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @video.reload
    assert @video.is_diggable_by?(@user)
    assert !@video.is_diggable_by?(@friend1)
    assert !@video.is_diggable_by?(@same_game_user)
    assert !@video.is_diggable_by?(@stranger)  
    assert !@video.is_diggable_by?(@fan)
    assert !@video.is_diggable_by?(@idol) 
  end

  test "video feed" do
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
    assert !@idol.recv_feed?(@video)

    @video.update_attributes(:privilege => PrivilegedResource::OWNER)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)
    assert !@idol.recv_feed?(@video)
    
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)  
    assert !@idol.recv_feed?(@video)

    @video.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
    assert @fan.recv_feed?(@video)
    assert !@idol.recv_feed?(@video)

    @video.unverify
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@video)
    assert !@guild1.recv_feed?(@video)
    assert !@guild2.recv_feed?(@video)
    assert !@game.recv_feed?(@video)
    assert !@profile.recv_feed?(@video)
    assert !@fan.recv_feed?(@video)  
    assert !@idol.recv_feed?(@video)

    @video.verify
    @friend1.reload and @game.reload and @profile.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed?(@video)
    assert @guild1.recv_feed?(@video)
    assert @guild2.recv_feed?(@video)
    assert @game.recv_feed?(@video)
    assert @profile.recv_feed?(@video)
    assert @fan.recv_feed?(@video)
    assert !@idol.recv_feed?(@video)
  end

  test "share video" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert @video.is_shareable_by?(@same_game_user)
    assert @video.is_shareable_by?(@stranger)
    assert @video.is_shareable_by?(@fan)
    assert @video.is_shareable_by?(@idol)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert @video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)
    assert @video.is_shareable_by?(@fan)
    assert @video.is_shareable_by?(@idol)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @video.is_shareable_by?(@user)
    assert @video.is_shareable_by?(@friend1)
    assert !@video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)
    assert @video.is_shareable_by?(@fan)
    assert @video.is_shareable_by?(@idol)

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @video.is_shareable_by?(@user)
    assert !@video.is_shareable_by?(@friend1)
    assert !@video.is_shareable_by?(@same_game_user)
    assert !@video.is_shareable_by?(@stranger)
    assert !@video.is_shareable_by?(@fan)
    assert !@video.is_shareable_by?(@idol)
  end

  test "sensitive video" do
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

  test "comment video" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert @video.is_commentable_by?(@same_game_user)
    assert @video.is_commentable_by?(@stranger)
    assert @video.is_commentable_by?(@fan)
    assert @video.is_commentable_by?(@idol)   

    assert_no_difference "Comment.count" do
      @video.comments.create :poster_id => @user.id, :recipient_id => nil, :content => 'a'
    end

    [@user, @friend1, @same_game_user, @stranger, @fan, @idol].each do |u|
      comment = @video.comments.create :poster_id => u.id, :content => 'comment', :recipient_id => @user.id
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend1, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end 
    
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert @video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    assert @video.is_commentable_by?(@fan)
    assert @video.is_commentable_by?(@idol)
    
    [@user, @friend1, @same_game_user, @fan, @idol].each do |u|
      comment = @video.comments.create :poster_id => u.id, :content => 'comment', :recipient_id => @user.id
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend1, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end 

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND

    assert @video.is_commentable_by?(@user)
    assert @video.is_commentable_by?(@friend1)
    assert !@video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    assert @video.is_commentable_by?(@fan)
    assert @video.is_commentable_by?(@idol)
 
    [@user, @friend1, @fan, @idol].each do |u|
      comment = @video.comments.create :poster_id => u.id, :content => 'comment', :recipient_id => @user.id
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend1, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end

    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER

    assert @video.is_commentable_by?(@user)
    assert !@video.is_commentable_by?(@friend1)
    assert !@video.is_commentable_by?(@same_game_user)
    assert !@video.is_commentable_by?(@stranger)
    assert !@video.is_commentable_by?(@fan)
    assert !@video.is_commentable_by?(@idol)
  
    [@user].each do |u|
      comment = @video.comments.create :poster_id => u.id, :content => 'comment', :recipient_id => @user.id
      assert comment.is_deleteable_by?(@user)
      ([@friend1, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end   
  end

  test "comment notice" do
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :new_friend_tags => [@friend1.id, @friend2.id]
    
    assert_difference "Notice.count", 2 do
      @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @user.id
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert !@user.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @video.comments.create :poster_id => @friend1.id, :content => 'comment', :recipient_id => @user.id
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert @user.recv_notice?(@comment)
    assert !@friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 3 do
      @comment = @video.comments.create :poster_id => @fan.id, :content => 'comment', :recipient_id => @friend1.id
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert @user.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 3 do
      @comment = @video.comments.create :poster_id => @user.id, :content => 'comment', :recipient_id => @fan.id
    end
    @user.reload and @friend1.reload and @friend2.reload and @fan.reload
    assert !@user.recv_notice?(@comment)
    assert @fan.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)
  end
  
  test "relative video" do
    # acts_as_privileged_resource在video_test.rb里已经测过了
    @video1 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 1.day.ago, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id]
    @video2 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 2.days.ago, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend1.id]
    @video3 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 3.days.ago, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]
    @video4 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 4.days.ago, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend1.id]
    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 3.days.ago, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]

    # video index
    @videos = @user.videos.for('owner')
    assert_equal @videos, [@video1, @video2, @video3, @video4]

    @videos = @user.videos.for('friend')
    assert_equal @videos, [@video1, @video2, @video3]

    @videos = @user.videos.for('same_game')
    assert_equal @videos, [@video1, @video2]

    @videos = @user.videos.for('stranger')
    assert_equal @videos, [@video1]

    # friend videos
    @videos = Video.by(@friend1.friend_ids)
    assert_equal @videos, [@video1, @video2, @video3, @video4]
    
    @videos = Video.by(@friend1.friend_ids).for('friend')
    assert_equal @videos, [@video1, @video2, @video3]

    # relative videos
    @videos = @friend1.relative_videos
    assert_equal @videos, [@video1, @video2, @video3, @video4]

    @videos = @friend1.relative_videos.for('friend')
    assert_equal @videos, [@video1, @video2, @video3]

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
