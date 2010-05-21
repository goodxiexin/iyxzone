class CreateSubdomains < ActiveRecord::Migration
  def self.up
    create_table :subdomains do |t|
      t.integer :user_id
      t.string :name
    end
  end

  def self.down
    drop_table :subdomains
  end
end
