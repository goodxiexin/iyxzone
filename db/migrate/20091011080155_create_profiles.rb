class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :gender # duplication of gender in user table
      t.string :login # duplication of login in user table
      t.integer :region_id
      t.integer :city_id
      t.integer :district_id
      t.string :qq
      t.string :phone
      t.string :website
      t.datetime :birthday
      t.text :about_me
      t.integer :completeness, :default => 0
      t.integer :skin_id, :default => 1
    end
  end

  def self.down
    drop_table :profiles
  end
end
