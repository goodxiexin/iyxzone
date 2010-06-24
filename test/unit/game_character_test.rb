require 'test_helper'

class GameCharacterTest < ActiveSupport::TestCase

  def setup
		@game = GameFactory.create
		@game1 = GameFactory.create(:no_areas => true)
		@game2 = GameFactory.create(:no_races => true)
		@game3 = GameFactory.create(:no_races => true, :no_professions => true)

		@user = UserFactory.create
  end

	test "初始值" do
		assert @game1.no_areas
		assert @game2.no_races
		assert @game3.no_professions
	end
 
  test "合法性" do
		# 用户id
    game_character1 = GameCharacter.new(:user_id => nil, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character1.save

		# 游戏
    game_character1 = GameCharacter.new(:user_id => @user.id, :game_id => nil, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character1.save

    game_character2 = GameCharacter.new(:user_id => @user.id, :game_id => 20000, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character2.save

    game_character3 = GameCharacter.new(:user_id => @user.id, :game_id => 100, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character3.save


		# 没名字
    game_character1 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => nil, :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character1.save

		# 等级
    game_character1 = GameCharacter.new(:user_id => @user.id, :name => 'hahaer', :game_id => @game.id, :level => nil, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character1.save

    game_character2 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 'hahaer', :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character2.save

		# area_id
    game_character1 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character1.save

    game_character8 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => 10, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character8.save

    game_character2 = GameCharacter.new(:user_id => @user.id, :game_id => @game1.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => @game1.servers.first.id, :race_id => @game1.races.first.id, :profession_id => @game1.professions.first.id)
    assert game_character2.save
		
		# server
    game_character3 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => nil, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character3.save

    game_character9 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => 20, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !game_character9.save

		# races
    game_character4 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => nil, :profession_id => @game.professions.first.id)
    assert !game_character4.save

    game_character10 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => 10, :profession_id => @game.professions.first.id)
    assert !game_character10.save

    game_character5 = GameCharacter.new(:user_id => @user.id, :game_id => @game2.id, :name => 'hahaer', :level => 70, :area_id => @game2.areas.first.id, :server_id => @game2.servers.first.id, :race_id => nil, :profession_id => @game2.professions.first.id)
    assert game_character5.save

		# professions
    game_character6 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => nil)
    assert !game_character6.save

    game_character7 = GameCharacter.new(:user_id => @user.id, :game_id => @game2.id, :name => 'hahaer', :level => 70, :area_id => @game2.areas.first.id, :server_id => @game2.servers.first.id, :race_id => nil, :profession_id => nil)
    assert !game_character7.save

    game_character12 = GameCharacter.new(:user_id => @user.id, :game_id => @game3.id, :name => 'hahaer', :level => 70, :area_id => @game3.areas.first.id, :server_id => @game3.servers.first.id, :race_id => nil , :profession_id => nil)
    assert game_character12.save

    game_character11 = GameCharacter.new(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => 20)
    assert !game_character11.save

  end
 
  test "计数器" do
    assert_difference "@game.reload.characters_count" do
      assert_difference "@user.reload.characters_count" do
        @character = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
      end
    end
 
    assert_difference "@game.reload.characters_count", -1 do
      assert_difference "@user.reload.characters_count", -1 do 
        @character.destroy
      end
    end
  end  

end
  
