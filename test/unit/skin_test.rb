require 'test_helper'

class SkinTest < ActiveSupport::TestCase

  def setup
    @user1 = UserFactory.create
    @profile1 = @user1.profile
    @user2 = UserFactory.create
    @profile2 = @user2.profile
    @user3 = UserFactory.create
    @profile3 = @user3.profile
  end

  test "create skin with invalid parameters" do
    skin = Skin.create(:name => "default", :css => "home", :thumbnail => "default.png", :category => nil, :privilege => Skin::PUBLIC)
    assert_not_nil skin.errors.on(:category)

    skin = Skin.create(:name => "default", :css => "home", :thumbnail => "default.png", :category => 'Profile', :privilege => nil)
    assert_not_nil skin.errors.on(:privilege)
 
    skin = Skin.create(:name => "default", :css => "home", :thumbnail => "default.png", :category => 'pp', :privilege => Skin::PUBLIC)
    assert_not_nil skin.errors.on(:category)
  end

  test "simply create a public skin" do
    skin = Skin.create(:name => "default", :css => "home", :thumbnail => "default.png", :category => 'Profile')
  
    assert skin.is_public?
    assert skin.access_list.blank?
    assert skin.accessible_for?(@profile1)
  end

  test "create a private skin" do
    skin = Skin.create(:name => "default", :css => "home", :thumbnail => "default.png", :category => 'Profile', :category => 'Profile', :privilege => Skin::PRIVATE)
 
    assert !skin.is_public?
    assert skin.access_list.blank?
    assert !skin.accessible_for?(@profile1)

    # add user to access list
    skin.access_list = [@profile1.id]
    skin.save
    
    skin.reload
    assert_equal skin.access_list, [@profile1.id]
    assert skin.accessible_for?(@profile1)

    # add another user to access list
    skin.access_list = skin.access_list.push @profile2.id
    skin.save    

    skin.reload
    assert_equal skin.access_list, [@profile1.id, @profile2.id]
    assert skin.accessible_for?(@profile2)

    # remove user1 from access list
    skin.access_list.shift
    skin.save

    skin.reload
    assert_equal skin.access_list, [@profile2.id]
    assert skin.accessible_for?(@profile2)
    assert !skin.accessible_for?(@profile1)
  end
  
  test "create multiple skins" do
    skin1 = Skin.create(:name => "default1", :css => "home", :thumbnail => "default.png", :category => 'Profile', :category => 'Profile', :privilege => Skin::PRIVATE, :created_at => 1.days.ago)
    skin2 = Skin.create(:name => "default2", :css => "home", :thumbnail => "default.png", :category => 'Profile', :category => 'Profile', :privilege => Skin::PRIVATE, :created_at => 2.days.ago)
    skin3 = Skin.create(:name => "default3", :css => "home", :thumbnail => "default.png", :category => 'Profile', :category => 'Profile', :privilege => Skin::PRIVATE, :created_at => 3.days.ago)
    skin4 = Skin.create(:name => "default4", :css => "home", :thumbnail => "default.png", :category => 'Profile', :category => 'Profile', :privilege => Skin::PUBLIC, :created_at => 4.days.ago)

    skin1.access_list = [@profile1.id, @profile2.id]
    skin2.access_list = [@profile2.id, @profile3.id]
    skin3.access_list = [@profile3.id, @profile1.id]
    skin1.save
    skin2.save
    skin3.save

    assert_equal @profile1.accessible_skins, [skin1, skin3, skin4]
    assert_equal @profile2.accessible_skins, [skin1, skin2, skin4]
    assert_equal @profile3.accessible_skins, [skin2, skin3, skin4]
  end

end
