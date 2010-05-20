class UserTask < ActiveRecord::Base
	
	belongs_to :task

	belongs_to :user

	serialize	:achievement, Hash

  validate_on_create :task_is_valid

  def notify_create resource
    task.requirements.each { |r| r.notify_create resource, achievement }
    self.save
  end

  def is_done?
    task.requirements.all? {|r| r.satisfy? achievement}
  end

  before_create :initialize_achievements

protected

  def task_is_valid
    return if user_id.blank? or task_id.blank?

    if task.blank?
      errors.add(:task_id, "不存在")
    elsif !task.is_selectable_by?(user)
      errors.add(:task_id, "不能选择")
    end
  end

  def initialize_achievements
    self.achievement = {}
    task.requirements.each do |r|
      r.init_achievement achievement
    end
  end

end
