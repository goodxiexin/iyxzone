class GuildRule < ActiveRecord::Base

  belongs_to :guild

  ABSENCE  = 0
  PRESENCE = 1

  def is_attendance_rule?
    rule_type == ABSENCE or rule_type == PRESENCE
  end

  def validate
    if reason.blank?
      errors.add_to_base("原因为空")
      return
    end

    if outcome.blank?
      errors.add_to_base("赏罚为空")
      return
    end
  end

  def validate_on_create
    return unless errors.on_base.blank?

    if guild_id.blank?
      errors.add_to_base("没有工会")
      return
    elsif Guild.find(:first, :conditions => {:id => guild_id}).blank?
      errors.add_to_base("工会不存在")
      return
    end

    if is_attendance_rule?
      errors.add_to_base("不能创建出勤规则")
      return
    end   
  end

  def validate_on_update
    return unless errors.on_base.blank?
    
    if guild_id_changed?
      errors.add_to_base("不能修改guild_id")
    elsif rule_type_changed?
      errors.add_to_base("不能修改rule_type")
    elsif is_attendance_rule? and reason_changed?
      errors.add_to_base("出勤规则只能修改赏罚") 
    end
  end

end
