class ResourceHandler
  @@handler = {}
  def self.find_class resource
    @@handler[resource]
  end
  def self.regist(klass, *str)
    str.each do |s|
      @@hander[s] = klass
    end
  end
end

class Resource
end


class CounterResource < Resource
end

class BlogResource < CounterResource
  @@name = 'blogs'
  def self.register_me
    ResourceHandler.regist(self, "blogs_morethan", "blogs_add")
  end
  def initialize u
    @user = u
  end
  
  def get_from_user
    return @user.send(@@name+"_count")
  end
  
  def get_from_prerequisite prereq
    prereq["blogs_morethan"]
  end
 
  def get_from_goal goal
    goal["blogs_morethan"]
  end


  def self.get_goal_from_requirement req
    goal1 = req["blogs_morethan"]
    goal2 = req["blogs_add"]
    if goal2
      goal2 = goal2 + self.get_from_user
      if goal1
        return goal1 > goal2? goal1 : goal2
      else
        return goal2
      end
    else
      return goal1
    end
  end
  
  def satisfy_prereq? prereq
    pre_value = self.get_from_prerequisite prereq
    user_value = self.get_from_user
    # 如果有nil，直接返回正确吧
    begin 
      ans =  pre_value <= user_value
    rescue ArgumentError
      ans = true
    end
    return ans
  end

  def satisfy_goal? goal
    goal_value = self.get_from_goal goal
    user_value = self.get_from_user
    # 如果有nil，直接返回正确吧
    begin 
      ans =  goal_value >= user_value
    rescue ArgumentError
      ans = true
    end
    return ans
  end


end

#class ResourceJudge
class PrerequisiteJudge
  def initialize task, user
    @task = task
    @user = user
  end
  def prerequisite_satisfy?
    prerequisite_user_info_satisfy?
  end
  def prerequisite_user_info_satisfy?
    userinfos = task.prerequisite[:userinfo] ||= {}
    #得到不满足的user_info
    #也许得到ResourceClass的实例会更好
    @unsatify = userinfos.select do |userinfo|
      resource_class = ResourceHandler.find_class(userinfo)
      unless ui_class
        #也许应该报个错误
        return false
      else
        return resource_class.satisfy_prereq? task
      end
    end
    return @unsatisfy.empty?
  end
end


class GoalJudge
  def initialize user_task, user
    @user_task = user_task
    @user = user
  end
  def goal_satisfy?
    goals = user_task.goal
    @unsatify = goals.select do |goal|
      resource_class = ResourceHandler.find_class(goal)
      unless resource_class
        #也许应该报个错误
        return false
      else
        return resource_class.satisfy_goal? @user_task.goal
      end
    end
    return @unsatisfy.empty?
  end
end

class UserTaskFactory

  def self.generate user, task
    UserTask.delete_all({:user_id => user.id, :task_id => task.id})
    user_task = UserTask.new(:user_id => user.id, :task_id => task.id)
    self.init_user_task_resource user_task
    self.init_time user_task, task
  end
#TODO: cut from user_task#init_achievement_and goal
#TODO: TO Modify
  def init_user_task user_task,task, user
    goal = {}
    	task.requirement.each do |key, value|
			if m = /(.*)_add$/.match(key)
				#achievement[m[1]] = user.send( m[1] + "_count" )
				goal_of_add = user.send( m[1] + "_count" ) + value
				goal[m[1]] =  goal[ m[1] ] ?  goal_of_add > goal[ m[1]] ? goal_of_add: goal[m[1]] : goal_of_add
			elsif m = /(.*)_morethan$/.match(key)
				#achievement[m[1]] = user.send( m[1] + "_count" )
				goal[m[1]] =  goal[ m[1] ] ?  value > goal[ m[1]] ? value : goal[m[1]]  : value
			else
				logger.error "unexpected requirement item: #{key}"
			end
		end
		
		#self.achievement = achievement
		self.goal = goal
  end
  def init_time user_task, task
    user_task.starts_at = DateTime.now
		user_task.expires_at = (user_task.starts_at.since(task.duration) > task.expires_at) ? task.expires_at : user_task.starts_at.since(task.duration)  
  end
end
