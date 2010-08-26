class CreateCaptchas < ActiveRecord::Migration
  def self.up
    create_table :captchas do |t|
      t.string :token
      t.string :code
    end
  end

  def self.down
    drop_table :captchas
  end
end
