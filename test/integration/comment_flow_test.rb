require 'test_helper'

class CommentFlowTest < ActionController::IntegrationTest
  # 只用blog来测试

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

    @friend = UserFactory.create
    FriendFactory.create @user, @friend

    @stranger = UserFactory.create

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

		@user_sess = login @user
		@friend_sess = login @friend
		@stranger_sess = login @stranger
	end

	test "POST create & DELETE destroy" do
		@user_sess.get "blogs/#{@blog.id}"

		assert_difference "@blog.comments.count" do
			@user_sess.post "comments", {:commentable_id => @blog.id, :commentable_type => 'Blog', "comment"=>{"recipient_id"=>"#{@user.id}", "content"=>"eaea"}}
		end
		@comment1 = Comment.last
    @user_sess.assert_template "user/comments/create.rjs"
		assert_difference "@blog.comments.count" do
			@friend_sess.post "comments", {:commentable_id => @blog.id, :commentable_type => 'Blog', "comment"=>{"recipient_id"=>"#{@user.id}", "content"=>"hehe"}}
		end
		@comment2 = Comment.last
    @user_sess.assert_template "user/comments/create.rjs"
		assert_difference "@blog.comments.count" do
			@friend_sess.post "comments", {:commentable_id => @blog.id, :commentable_type => 'Blog', "comment"=>{"recipient_id"=>"#{@user.id}", "content"=>"hehe"}}
		end
		@comment3 = Comment.last
		#assert_no_difference "@blog.comments.count" do
		#	@stranger_sess.post "comments", {:commentable_id => @blog.id, :commentable_type => 'Blog', "comment"=>{"recipient_id"=>"#{@user.id}", "content"=>"haha"}}
		#end

		#assert_no_difference "@blog.comments.count" do
		#	@stranger_sess.delete "comments/#{@comment2.id}"
		#end
		assert_difference "@blog.comments.count", -1 do
			@friend_sess.delete "comments/#{@comment3.id}"
		end
		assert_difference "@blog.comments.count", -1 do
			@user_sess.delete "comments/#{@comment2.id}"
		end
		assert_difference "@blog.comments.count", -1 do
			@user_sess.delete "comments/#{@comment1.id}"
		end
	end
end
