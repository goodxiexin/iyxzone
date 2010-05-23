module TasksHelper
#TODO: can move to TaskModel
	def show_task_state_of_user current_task, current_user
		case current_task.check_state(current_user.id)
		when Task::CANDO then
			"可以领取"
		when Task::CANNOTDO then
			"没达到要求或是任务没有开放"
		when Task::DONE then
			"已完成"
		when Task::EXPIRED then
			"任务超时"
		when Task::ACHIEVED then
			"领奖去"
		when Task::DOING then
			"还未完成，继续努力"
		else
			logger.error "不会到这里的……"
		end
	end

	def show_prerequisite 
		show_prerequisite_user_info +	show_prerequisite_pretask
	end

	def show_prerequisite_user_info 
		userinfo = @current_task.prerequisite[:userinfo] ||= {}
#TODO: 措辞不当
		ul = ''
		disp = ''
		unless userinfo.empty?
			disp = content_tag :h2, "用户要达到的水平"
			lis = userinfo.inject('') do |list, pair|
				list += content_tag(:li, show_prerequired_item_and_user_counter(pair) )	
			end
			ul = content_tag :ul, lis
		end
		content_tag :div, disp + ul
	end

	def show_prerequisite_pretask
		pretask = @current_task.prerequisite[:pretask] ||= []
		disp = ''
		ul = ''
		unless pretask.empty?
			disp = content_tag :h2, "先要完成的任务"
			
			lis = pretask.inject('') do |list, pt|
				list += content_tag(:li, link_to("任务#{pt}",task_path(pt)) )
			end
			ul = content_tag :ul, lis
		end

		content_tag :div, disp + ul
	end

#TODO: HOW TO get user_counter here?
	def show_prerequired_item_and_user_counter pair
		case pair[0]
#TODO: two match operations are expensive
		when /^(.*)_morethan$/
			resource = pair[0][/^(.*)_morethan$/, 1]
			content_tag(:p, get_chinese(resource) + "达到#{pair[1]}")
		else
#should never goes here
			logger.error "unexpected task resources in TASK #{@current_task.id}: #{pair[0]}"
		end
	end

#TODO: "blogs" => "日志", blablabla
	def get_chinese(res)
		res
	end

	def test_self
		logger.error  self.class
	end

end
