class AddMiniBlogMailSetting < ActiveRecord::Migration
  def self.up
    # NOTHING TO DO
    # 因为新的2个选项是加在最高位的，都是0，那所有值不需要改变
  end

  def self.down
  end
end
