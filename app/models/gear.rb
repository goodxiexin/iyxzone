class Gear < ActiveRecord::Base

  belongs_to :guild

  belongs_to :boss

  def validate
    if name.blank?
      errors.add_to_base("没有名字")
      return
    end

    if cost.blank?
      errors.add_to_base("没有成本")
      return
    elsif cost <= 0
      errors.add_to_base("成本必须是正数")
      return
    end

  end

  def validate_on_create
    return unless errors.on_base.blank?

=begin
    if boss_id.blank?
      errors.add_to_base("没有boss")
      return
    elsif Boss.find(:first, :conditions => {:id => boss_id}).blank?
      errors.add_to_base("boss不存在")
      return
    end
=end

    # guild_id 不用检查，被自动赋值
    if guild_id.blank?
      errors.add_to_base("没有工会")
      return
    elsif Guild.find(:first, :conditions => {:id => guild_id}).blank?
      errors.add_to_base("工会不存在")
      return
    end
  end

  def validate_on_update
    return unless errors.on_base.blank?
  
    if boss_id_changed?
      errors.add_to_base("不能修改boss_id")
      return
    elsif guild_id_changed?
      errors.add_to_base("不能修改guild_id")
      return
    end
  end
  
end
