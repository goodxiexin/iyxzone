require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Replace this with your real tests.
	@@i = 0
  test "the truth" do
    assert true
  end

	test "01" +"simple task create" do
		puts check_exist_id.inspect	
		t1 = Task.new(
			:prerequisite	=> {},
			:requirement	=> {},
			:description	=> {:title => "测试任务1", :thumbnail => "default_event_large.png",
												:text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		assert(t1.valid?)
		t1.save
	end

	test "02" +"prerequisite userinfo task create" do
		t2 = Task.new(
			:prerequisite	=> {:userinfo => {"participated_polls_morethan" => 1} },
			:requirement	=> {},
			:description	=> {:title => "测试任务2", :thumbnail => "default_event_large.png",
												:text => "这仍然是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		assert(t2.valid?)
		t2.save
	end

	test "03" +"prerequisite pretask task create" do
		puts check_exist_id.inspect	
		t3 = Task.new(
			:prerequisite	=> {:pretask => [2] },
			:requirement	=> {},
			:description	=> {:title => "测试任务3", :thumbnail => "default_event_large.png",
												:text => "这仍然是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		t3.valid?
		puts t3.errors.inspect
		assert(t3.valid?)
		t3.save
	end

	test "04" + "prerequisite pretask and userinfo task create" do
		t4 = Task.new(
			:prerequisite	=> {:userinfo => {"blogs_morethan" => 1, "participated_polls_morethan" => 1}, :pretask => [1,2] },
			:requirement	=> {},
			:description	=> {:title => "测试任务4", :thumbnail => "default_event_large.png",
												:text => "这仍然是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		assert(t4.valid?)
		t4.save
	end
	test "05" + "prerequisite requirement task create" do
		t5 = Task.new(
			:prerequisite	=> {:userinfo => {"blogs_morethan" => 1, "participated_polls_morethan" => 1}, :pretask => [1,2] },
			:requirement	=> {"blogs_morethan" => 1, "albums_add" => 2},
			:description	=> {:title => "测试任务5", :thumbnail => "default_event_large.png",
												:text => "这仍然是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		assert(t5.valid?)
		t5.save
	end
	def setup
			dyc = User.new
			dyc.login = "dyc"
			dyc.password = "123123"
			dyc.password_confirmation = "123123"
			dyc.email = "silentdai@gmail.com"
			dyc.save(false)
			dyc.activate
			role = Role.create(:name => 'dyc')
    	RoleUser.create(:role_id => role.id, :user_id => dyc.id)
		t1 = Task.new(
			:prerequisite	=> {:userinfo => {"blogs_morethan" => 1}},
			:requirement	=> {"blogs_morethan" => 3},
			:description	=> {:title => "测试任务1", :thumbnail => "default_event_large.png",
												:text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10000,
			:duration			=> 10000,
			:catagory	=> 2
#			:state	=> 1
			)
		t1.save

		t2 = Task.new(
			:prerequisite	=> {:userinfo => {"blogs_morethan" => 2, "participated_polls_morethan" => 1 }, :pretask => [t1.id]},
			:requirement	=> {"blogs_morethan" => 3, "blogs_add" => 2},
			:description	=> {:title => "测试任务1", :thumbnail => "default_event_large.png",
												:text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10000,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
		t2.save
	end

	def check_exist_id
		Task.all.collect {|x| x.id}
	end
end
