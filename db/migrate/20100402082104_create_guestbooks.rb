class CreateGuestbooks < ActiveRecord::Migration
  def self.up
		create_table :guestbooks do |t|
			t.integer	:user_id
			t.text	 	:description
			t.integer :priority
			t.date		:done_date
			t.text		:reply
			t.string	:catagory

			t.timestamps
		end
  end

  def self.down
		drop_table :guestbooks
  end
end
