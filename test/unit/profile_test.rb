require 'test_helper'

class ProfileTest < ActiveSupport::TestCase

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

    [@user, @friend, @same_game_user, @stranger, @idol, @fan].each {|u| u.reload}
  end
  
  test "profile inherits some attributes from user" do
    assert_equal @profile.login, @user.login
    assert_equal @profile.gender, @user.gender
  end 
  
  test "edit/update profile" do
    # change gender
    assert @profile.update_attributes(:gender => 'female')
    assert_equal @user.reload.gender, 'female'
    assert @profile.update_attributes(:gender => 'male')
    assert_equal @user.reload.gender, 'male'
    assert !@profile.update_attributes(:gender => nil)

    # change login
    @profile.reload
    assert @profile.update_attributes(:login => 'gaoxiahong')
    assert_equal @user.reload.login, 'gaoxiahong'
    assert @profile.update_attributes(:login => 'gaoxh')
    assert_equal @user.reload.login, 'gaoxh'
    assert !@profile.update_attributes(:login => nil)
    
    # change birthday
    @profile.reload
    assert !@profile.update_attributes(:birthday => Time.now)
    assert !@profile.update_attributes(:birthday => 50.years.ago)
    assert @profile.update_attributes(:birthday => 18.years.ago)
    assert @profile.update_attributes(:birthday => nil)

    # change district??
    # TODO
    @profile.reload
    assert @profile.update_attributes(:region_id => @region1.id, :city_id => nil, :district_id => nil)
    assert @profile.update_attributes(:region_id => @region1.id, :city_id => @city1.id, :district_id => nil)
    assert @profile.update_attributes(:region_id => @region1.id, :city_id => @city1.id, :district_id => @district1.id)
    assert @profile.update_attributes(:region_id => nil, :city_id => nil, :district_id => nil)
    assert @profile.update_attributes(:region_id => @region2.id, :city_id => nil, :district_id => nil)
    assert !@profile.update_attributes(:region_id => @region1.id, :city_id => @city2.id, :district_id => nil)
    assert !@profile.update_attributes(:region_id => @region1.id, :city_id => @city1.id, :district_id => @district2.id)
    assert !@profile.update_attributes(:region_id => @region1.id, :city_id => nil, :district_id => @district1.id)

    # change qq
    @profile.reload
    assert @profile.update_attributes(:qq => '12345678')
    assert !@profile.update_attributes(:qq => 'invalid')
    assert !@profile.update_attributes(:qq => '11')
    assert !@profile.update_attributes(:qq => '1111111111111111111111')
    assert @profile.update_attributes(:qq => nil)

    # change phone
    @profile.reload
    assert @profile.update_attributes(:phone => '021-66253696')
    assert !@profile.update_attributes(:phone => 'invalid')
    assert !@profile.update_attributes(:phone => '11')
    assert !@profile.update_attributes(:phone => '021-021-021-021-66253696')
    assert @profile.update_attributes(:phone => nil)

    # change website
    @profile.reload
    assert !@profile.update_attributes(:website => '&^ASD')
    assert @profile.update_attributes(:website => 'www.baidu.com')
    assert @profile.update_attributes(:website => nil)
  end
 
  # TODO
  # 其实这个语义的接口很奇怪，应该可以改进 
  test "acts as viewable" do
    assert !@profile.is_viewable_by?(@user)
    assert @profile.is_viewable_by?(@friend)
    assert @profile.is_viewable_by?(@same_game_user)
    assert @profile.is_viewable_by?(@stranger)
  end 

  test "share profile" do
    # normal user
    @user.privacy_setting.update_attributes(:profile => 1)
    assert @profile.is_shareable_by?(@user)
    assert @profile.is_shareable_by?(@friend)
    assert @profile.is_shareable_by?(@same_game_user)
    assert @profile.is_shareable_by?(@stranger)
  
    @user.privacy_setting.update_attributes(:profile => 2)
    @profile.reload # reload profile.user
    assert @profile.is_shareable_by?(@user)
    assert @profile.is_shareable_by?(@friend)
    assert @profile.is_shareable_by?(@same_game_user)
    assert !@profile.is_shareable_by?(@stranger)

    @user.privacy_setting.update_attributes(:profile => 3)
    @profile.reload # reload profile.user
    assert @profile.is_shareable_by?(@user)
    assert @profile.is_shareable_by?(@friend)
    assert !@profile.is_shareable_by?(@same_game_user)
    assert !@profile.is_shareable_by?(@stranger)
  
    # idol
    @idol.privacy_setting.update_attributes(:profile => 1)
    assert @idol_profile.is_shareable_by?(@user)
    assert @idol_profile.is_shareable_by?(@friend)
    assert @idol_profile.is_shareable_by?(@same_game_user)
    assert @idol_profile.is_shareable_by?(@stranger)
    assert @idol_profile.is_shareable_by?(@fan)
    assert @idol_profile.is_shareable_by?(@idol_idol)

    @idol.privacy_setting.update_attributes(:profile => 2)
    assert @idol_profile.is_shareable_by?(@user)
    assert @idol_profile.is_shareable_by?(@friend)
    assert @idol_profile.is_shareable_by?(@same_game_user)
    assert @idol_profile.is_shareable_by?(@stranger)
    assert @idol_profile.is_shareable_by?(@fan)
    assert @idol_profile.is_shareable_by?(@idol_idol)

    @idol.privacy_setting.update_attributes(:profile => 3)
    assert @idol_profile.is_shareable_by?(@user)
    assert @idol_profile.is_shareable_by?(@friend)
    assert @idol_profile.is_shareable_by?(@same_game_user)
    assert @idol_profile.is_shareable_by?(@stranger)
    assert @idol_profile.is_shareable_by?(@fan)
    assert @idol_profile.is_shareable_by?(@idol_idol)
  end

  test "comment profile" do
    # normal user
    @user.privacy_setting.update_attributes(:leave_wall_message => 1)
    @profile.reload
    assert @profile.is_commentable_by?(@user)
    assert @profile.is_commentable_by?(@friend)
    assert @profile.is_commentable_by?(@same_game_user)
    assert @profile.is_commentable_by?(@stranger)
    [@user, @friend, @same_game_user, @stranger].each do |u|
      @comment = @profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      [@friend, @same_game_user, @stranger].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end 

    @user.privacy_setting.update_attributes(:leave_wall_message => 2)
    @profile.reload
    assert @profile.is_commentable_by?(@user)
    assert @profile.is_commentable_by?(@friend)
    assert @profile.is_commentable_by?(@same_game_user)
    assert !@profile.is_commentable_by?(@stranger)
    [@user, @friend, @same_game_user].each do |u|
      @comment = @profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      [@friend, @same_game_user, @stranger].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end 

    @user.privacy_setting.update_attributes(:leave_wall_message => 3)
    @profile.reload
    assert @profile.is_commentable_by?(@user)
    assert @profile.is_commentable_by?(@friend)
    assert !@profile.is_commentable_by?(@same_game_user)
    assert !@profile.is_commentable_by?(@stranger)
    [@user, @friend].each do |u|
      @comment = @profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      [@friend, @same_game_user, @stranger].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end 

    # idol
    @idol.privacy_setting.update_attributes(:leave_wall_message => 1)
    @idol_profile.reload
    assert @idol_profile.is_commentable_by?(@idol)
    assert @idol_profile.is_commentable_by?(@friend)
    assert @idol_profile.is_commentable_by?(@same_game_user)
    assert @idol_profile.is_commentable_by?(@stranger)
    assert @idol_profile.is_commentable_by?(@fan)
    assert @idol_profile.is_commentable_by?(@idol_idol)
    [@idol, @friend, @same_game_user, @stranger, @fan, @idol_idol].each do |u|
      @comment = @idol_profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@idol)
      [@friend, @same_game_user, @stranger, @fan, @idol_idol].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end

    @idol.privacy_setting.update_attributes(:leave_wall_message => 2)
    @idol_profile.reload
    assert @idol_profile.is_commentable_by?(@idol)
    assert @idol_profile.is_commentable_by?(@friend)
    assert @idol_profile.is_commentable_by?(@same_game_user)
    assert @idol_profile.is_commentable_by?(@stranger)
    assert @idol_profile.is_commentable_by?(@fan)
    assert @idol_profile.is_commentable_by?(@idol_idol)
    [@idol, @friend, @same_game_user, @stranger, @fan, @idol_idol].each do |u|
      @comment = @idol_profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@idol)
      [@friend, @same_game_user, @stranger, @fan, @idol_idol].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end

    @idol.privacy_setting.update_attributes(:leave_wall_message => 3)
    @idol_profile.reload
    assert @idol_profile.is_commentable_by?(@idol)
    assert @idol_profile.is_commentable_by?(@friend)
    assert @idol_profile.is_commentable_by?(@same_game_user)
    assert @idol_profile.is_commentable_by?(@stranger)
    assert @idol_profile.is_commentable_by?(@fan)
    assert @idol_profile.is_commentable_by?(@idol_idol)
    [@idol, @friend, @same_game_user, @stranger, @fan, @idol_idol].each do |u|
      @comment = @idol_profile.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@idol)
      [@friend, @same_game_user, @stranger, @fan, @idol_idol].each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end

  end
  
  test "tag profile" do
    # normal user
    assert !@profile.is_taggable_by?(@user)
    assert @profile.is_taggable_by?(@friend)
    assert !@profile.is_taggable_by?(@same_game_user)
    assert !@profile.is_taggable_by?(@stranger)
    
    assert_difference "Tag.count" do
      assert_difference "@user.reload.notifications_count" do
        @profile.add_tag(@friend, 'sb')
      end
    end

    # 如果创建不成功，tag不会被删除，这种没用的tag会在一定时间内被后台任务删除
    assert_difference "Tag.count" do
      assert_no_difference "@user.reload.notifications_count" do
        @profile.add_tag(@friend, 'cnm')
      end
    end

    @tagging = Tagging.last
    @tagging.created_at = 2.weeks.ago
    @tagging.save

    assert_no_difference "Tag.count" do
      assert_difference "@user.reload.notifications_count" do
        @profile.add_tag(@friend, 'cnm')
      end
    end

    assert @profile.is_tag_deleteable_by?(@user)
    assert !@profile.is_tag_deleteable_by?(@friend)
    assert !@profile.is_tag_deleteable_by?(@same_game_user)
    assert !@profile.is_tag_deleteable_by?(@stranger)
  
    # idol 
    assert !@idol_profile.is_taggable_by?(@idol)
    assert @idol_profile.is_taggable_by?(@friend)
    assert !@idol_profile.is_taggable_by?(@same_game_user)
    assert !@idol_profile.is_taggable_by?(@stranger)
    assert @idol_profile.is_taggable_by?(@fan)
    assert @idol_profile.is_taggable_by?(@idol_idol)

    assert_no_difference "Tag.count" do
      assert_difference "@idol.reload.notifications_count" do
        @idol_profile.add_tag(@friend, 'sb')
      end
    end

    @tagging = Tagging.last
    @tagging.created_at = 2.weeks.ago
    @tagging.save

    assert_difference "Tag.count" do
      assert_difference "@idol.reload.notifications_count" do
        @idol_profile.add_tag(@friend, 'chunge')
      end
    end

    assert @idol_profile.is_tag_deleteable_by?(@idol)
    assert !@idol_profile.is_tag_deleteable_by?(@friend)
    assert !@idol_profile.is_tag_deleteable_by?(@same_game_user)
    assert !@idol_profile.is_tag_deleteable_by?(@stranger)
  end

  test "profile feeds" do
    assert @profile.update_attributes :gender => 'female'
    @friend.reload and @profile.reload
    assert @friend.recv_feed?(@profile)
    assert @profile.recv_feed?(@profile)
    @profile.destroy_feeds

    assert @profile.update_attributes :phone => '66253696'
    @friend.reload and @profile.reload
    assert @friend.recv_feed?(@profile)
    assert @profile.recv_feed?(@profile)

    # idol
    assert @idol_profile.update_attributes :gender => 'female'
    @friend.reload and @fan.reload and @idol_profile.reload
    assert @friend.recv_feed?(@idol_profile)
    assert @fan.recv_feed?(@idol_profile)
    assert @idol_profile.recv_feed?(@idol_profile)
    @idol_profile.destroy_feeds

    assert @idol_profile.update_attributes :phone => '22222222'
    @friend.reload and @fan.reload and @idol_profile.reload
    assert @friend.recv_feed?(@idol_profile)
    assert @fan.recv_feed?(@idol_profile)
    assert @idol_profile.recv_feed?(@idol_profile)
  end

  test "completeness" do
    assert_more "@profile.reload.completeness" do
      @profile.update_attributes(:qq => '372123456', :phone => '66232345')
    end

    assert_less "@profile.reload.completeness" do
      @profile.update_attributes(:qq => nil)
    end

    assert_no_difference "@profile.reload.completeness" do
      @profile.update_attributes(:phone => '12341234')
    end
  end
  
  test "view basic info, contact info" do
    # normal user
    @user.privacy_setting.update_attributes(:basic_info => 1)
    @profile.reload
    assert @profile.basic_info_viewable? @user.relationship_with(@user)
    assert @profile.basic_info_viewable? @friend.relationship_with(@user)
    assert @profile.basic_info_viewable? @same_game_user.relationship_with(@user)
    assert @profile.basic_info_viewable? @stranger.relationship_with(@user)

    @user.privacy_setting.update_attributes(:basic_info => 2)
    @profile.reload
    assert @profile.basic_info_viewable? @user.relationship_with(@user)
    assert @profile.basic_info_viewable? @friend.relationship_with(@user)
    assert @profile.basic_info_viewable? @same_game_user.relationship_with(@user)
    assert !@profile.basic_info_viewable?(@stranger.relationship_with(@user))

    @user.privacy_setting.update_attributes(:basic_info => 3)
    @profile.reload
    assert @profile.basic_info_viewable? @user.relationship_with(@user)
    assert @profile.basic_info_viewable? @friend.relationship_with(@user)
    assert !@profile.basic_info_viewable?(@same_game_user.relationship_with(@user))
    assert !@profile.basic_info_viewable?(@stranger.relationship_with(@user))
  
    # only test qq
    @user.privacy_setting.update_attributes(:qq => 1)
    @profile.reload
    assert @profile.qq_viewable? @user.relationship_with(@user)
    assert @profile.qq_viewable? @friend.relationship_with(@user)
    assert @profile.qq_viewable? @same_game_user.relationship_with(@user)
    assert @profile.qq_viewable? @stranger.relationship_with(@user)

    @user.privacy_setting.update_attributes(:qq => 2)
    @profile.reload
    assert @profile.qq_viewable? @user.relationship_with(@user)
    assert @profile.qq_viewable? @friend.relationship_with(@user)
    assert @profile.qq_viewable? @same_game_user.relationship_with(@user)
    assert !@profile.qq_viewable?(@stranger.relationship_with(@user))

    @user.privacy_setting.update_attributes(:qq => 3)
    @profile.reload
    assert @profile.qq_viewable? @user.relationship_with(@user)
    assert @profile.qq_viewable? @friend.relationship_with(@user)
    assert !@profile.qq_viewable?(@same_game_user.relationship_with(@user))
    assert !@profile.qq_viewable?(@stranger.relationship_with(@user))
  
    # profile is available_for user
    @user.privacy_setting.update_attributes(:profile => 1)
    @profile.reload
    assert @profile.available_for?(@user.relationship_with(@user))
    assert @profile.available_for?(@friend.relationship_with(@user))
    assert @profile.available_for?(@same_game_user.relationship_with(@user))
    assert @profile.available_for?(@stranger.relationship_with(@user))

    @user.privacy_setting.update_attributes(:profile => 2)
    @profile.reload
    assert @profile.available_for?(@user.relationship_with(@user))
    assert @profile.available_for?(@friend.relationship_with(@user))
    assert @profile.available_for?(@same_game_user.relationship_with(@user))
    assert !@profile.available_for?(@stranger.relationship_with(@user))

    @user.privacy_setting.update_attributes(:profile => 3)
    @profile.reload
    assert @profile.available_for?(@user.relationship_with(@user))
    assert @profile.available_for?(@friend.relationship_with(@user))
    assert !@profile.available_for?(@same_game_user.relationship_with(@user))
    assert !@profile.available_for?(@stranger.relationship_with(@user))
  
    # idol
    [1, 2, 3].each do |p|
      @idol.privacy_setting.update_attributes(:basic_info => p)
      @idol_profile.reload
      [@idol, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
        assert @idol_profile.basic_info_viewable? u.relationship_with(@idol)
      end
    
      @idol.privacy_setting.update_attributes(:qq => p)
      @idol_profile.reload
      [@idol, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
        assert @idol_profile.qq_viewable? u.relationship_with(@idol)
      end

      @idol.privacy_setting.update_attributes(:profile => p)
      @idol_profile.reload
      [@idol, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
        assert @idol_profile.available_for? u.relationship_with(@idol)
      end
    end
  end
  
  test "update character" do
    game_info = @user_character.game_info

    assert_difference "@user.reload.characters_count" do
      @profile.update_attributes(:new_characters => {"1" => game_info.merge({:name => 'a', :level => 100})})
    end
    @c1 = GameCharacter.last

    assert_difference "@user.reload.characters_count", 2 do
      @profile.update_attributes(:new_characters => {"1" => game_info.merge({:name => 'a', :level => 100}), "2" => game_info.merge({:name => 'a', :level => 200})})
    end
    @c2 = GameCharacter.all.reverse[1]
    @c3 = GameCharacter.last
  
    @profile.update_attributes(:existing_characters => {@c1.id => {:name => 'c1'}, @c2.id => {:name => 'c2'}, @c3.id => {:name => 'c3'}})
    assert_equal @c1.reload.name, 'c1'
    assert_equal @c2.reload.name, 'c2'
    assert_equal @c3.reload.name, 'c3'
 
    assert_difference "@user.reload.characters_count", -1 do
      @profile.update_attributes(:del_characters => [@c3.id])
    end

    assert_no_difference "@user.reload.characters_count" do
      @profile.update_attributes(:del_characters => [@c2.id], :new_characters => {"1" => game_info.merge({:name => 'b', :level => 100})}, :existing_characters => {@c1.id => {:name => 'new c1'}})
    end
    assert_equal @c1.reload.name, 'new c1'

    # TODO: if character is locked
  end

end

