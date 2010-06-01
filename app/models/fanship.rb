class Fanship < ActiveRecord::Base

  belongs_to :fan, :class_name => 'User'

  belongs_to :idol, :class_name => 'User', :conditions => {:is_idol => true}

  validate_on_create :idol_is_valid

protected

  def idol_is_valid
    return if idol_id.blank? or fan_id.blank?
    if idol.blank?
      errors.add(:idol_id, '偶像不存在')
    elsif idol.has_fan? fan_id
      errors.add(:idol_id, '已经是粉丝了')
    elsif idol.has_friend? fan_id
      errors.add(:idol_id, '已经是好友了，不能再是粉丝了')
    end
  end

end
