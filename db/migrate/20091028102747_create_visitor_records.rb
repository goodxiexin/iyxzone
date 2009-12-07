class CreateVisitorRecords < ActiveRecord::Migration
  def self.up
    create_table :visitor_records do |t|
			t.integer :visitor_id
			t.integer :profile_id
			t.datetime :created_at
    end
  end

  def self.down
    drop_table :visitor_records
  end
end
