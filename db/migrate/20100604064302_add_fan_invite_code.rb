class AddFanInviteCode < ActiveRecord::Migration
  def self.up
    add_column :users, :invite_fan_code, :string
  end

  def self.down
  end
end
