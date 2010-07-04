require 'test_helper'

class DigFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create 4 friends
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    @user.reload and @friend.reload

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

		@sharing = Share.create :url => "http://2010.sina.com.cn/"

		# login
		@user_sess = login @user
		@friend_sess = login @friend
  end

	test "POST create" do
		@user_sess.get "blogs/#{@blog.id}"
    assert_difference "@blog.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog.id, :at=>'show'}
    end
    @user_sess.assert_template "user/digs/create.rjs"

		@user_sess.get "blogs/recent"
    assert_no_difference "@blog.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog.id }
    end

    assert_difference "@blog1.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog1.id }
		end
    @user_sess.assert_template "user/digs/create.rjs"

		@user_sess.get "sharings/#{@sharing.id}"
    assert_difference "@sharing.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Share', :diggable_id => @sharing.id }
		end
    @user_sess.assert_template "user/digs/create.rjs"

	end
end
