class TaskPrerequisite

  attr_accessor :val

  def initialize val
    @val = val
  end

  def satisfy? user
  end

  def valid?
    true
  end

end

class PretasksPrerequisite < TaskPrerequisite

  def satisfy? user
    (user.user_tasks.select{|t| t.is_done?}.map(&:task_id) & val) == val
  end

  def valid
    val.is_a? Array
  end

end

class BlogMoreThanPrerequisite < TaskPrerequisite

  def satisfy? user
    user.blogs_count > val
  end

  def valid?
    val.is_a? Integer
  end

end

class ProfileCompletenessPrerequisite < TaskPrerequisite

  def satisfy? user
    user.profile.completenss > val
  end

  def valid?
    val.is_a? Integer
  end 

end
