class Boss < ActiveRecord::Base

  belongs_to :guild
  
  belongs_to :game

  has_many :gears

  def validate
    if name.blank?
      errors.add_to_base("没有名字")
      return
    end

    if reward.blank?
      errors.add_to_base("没有奖励")
      return
    elsif reward <= 0
      errors.add_to_base("奖励必须是正数")
      return
    end
  
    # game_id 被自动赋值，所以不用检查
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
  end

  def validate_on_update
    if guild_id_changed?
      errors.add_to_base("不能修改guild_id")
      return
    elsif game_id_changed?
      errors.add_to_base("不能修改game_id")
      return
    end
  end
end
