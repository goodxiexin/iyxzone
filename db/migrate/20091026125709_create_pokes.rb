class CreatePokes < ActiveRecord::Migration
  def self.up
    create_table :pokes do |t|
			t.string :name
      t.string :span_class
      t.string :content_html
    end
	end

  def self.down
    drop_table :pokes
  end
end
