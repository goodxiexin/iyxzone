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
    gameCharacter1 = GameCharacter.create(:user_id => nil, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter1.save

		# 游戏
    gameCharacter1 = GameCharacter.create(:user_id => @user.id, :game_id => nil, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter1.save

    gameCharacter2 = GameCharacter.create(:user_id => @user.id, :game_id => 20000, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter2.save

    gameCharacter3 = GameCharacter.create(:user_id => @user.id, :game_id => 100, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter3.save


		# 没名字
    gameCharacter1 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => nil, :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter1.save

		# 等级
    gameCharacter1 = GameCharacter.create(:user_id => @user.id, :name => 'hahaer', :game_id => @game.id, :level => nil, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter1.save

    gameCharacter2 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 'hahaer', :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter2.save

		# area_id
    gameCharacter1 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter1.save

    gameCharacter8 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => 10, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter8.save

    gameCharacter2 = GameCharacter.create(:user_id => @user.id, :game_id => @game1.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => @game1.servers.first.id, :race_id => @game1.races.first.id, :profession_id => @game1.professions.first.id)
    assert gameCharacter2.save
		
		# server
    gameCharacter3 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => nil, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter3.save

    gameCharacter9 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => nil, :server_id => 20, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
    assert !gameCharacter9.save

		# races
    gameCharacter4 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => nil, :profession_id => @game.professions.first.id)
    assert !gameCharacter4.save

    gameCharacter10 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => 10, :profession_id => @game.professions.first.id)
    assert !gameCharacter10.save

    gameCharacter5 = GameCharacter.create(:user_id => @user.id, :game_id => @game2.id, :name => 'hahaer', :level => 70, :area_id => @game2.areas.first.id, :server_id => @game2.servers.first.id, :race_id => nil, :profession_id => @game2.professions.first.id)
    assert gameCharacter5.save

		# professions
    gameCharacter6 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => nil)
    assert !gameCharacter6.save

    gameCharacter7 = GameCharacter.create(:user_id => @user.id, :game_id => @game2.id, :name => 'hahaer', :level => 70, :area_id => @game2.areas.first.id, :server_id => @game2.servers.first.id, :race_id => nil, :profession_id => nil)
    assert !gameCharacter7.save

    gameCharacter12 = GameCharacter.create(:user_id => @user.id, :game_id => @game3.id, :name => 'hahaer', :level => 70, :area_id => @game3.areas.first.id, :server_id => @game3.servers.first.id, :race_id => nil , :profession_id => nil)
    assert gameCharacter12.save

    gameCharacter11 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => 20)
    assert !gameCharacter11.save

  end
 
  test "计数器" do
    gameCharacter1 = GameCharacter.create(:user_id => @user.id, :game_id => @game.id, :name => 'hahaer', :level => 70, :area_id => @game.areas.first.id, :server_id => @game.servers.first.id, :race_id => @game.races.first.id, :profession_id => @game.professions.first.id)
		@game.reload
		@user.reload
    assert_equal @game.characters_count, 1
    assert_equal @user.characters_count, 1
  
    gameCharacter1.destroy
		@game.reload
		@user.reload
    assert_equal @game.characters_count, 0
    assert_equal @user.characters_count, 0
  end  

end
  
