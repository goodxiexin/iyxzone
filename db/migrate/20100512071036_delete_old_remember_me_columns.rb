class DeleteOldRememberMeColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
  end

  def self.down
  end
end
