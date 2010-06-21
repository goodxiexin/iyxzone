class CreateChineseCharacters < ActiveRecord::Migration
  def self.up
    create_table :chinese_characters, :force => true do |t|
      t.string :utf8_code
      t.string :pinyin
    end
    Pinyin::init_db
  end

  def self.down
    drop_table :chinese_characters
  end
end
