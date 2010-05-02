class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :reportable_id
      t.string :reportable_type
      t.string :content
      t.integer :poster_id
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
