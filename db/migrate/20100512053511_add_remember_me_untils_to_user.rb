class AddRememberMeUntilsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_me_untils, :datetime
  end

  def self.down
  end
end
