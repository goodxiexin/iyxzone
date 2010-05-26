class AddInviteeCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invitee_code, :string
  end

  def self.down
  end
end
