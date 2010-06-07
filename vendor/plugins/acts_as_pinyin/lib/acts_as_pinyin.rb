# ActsAsPinyin
require 'rubygems'

module Pinyin

  def acts_as_pinyin options={}
    define_method("before_save") do
      options.each do |column, pinyin_column|
        changed = eval("self.#{column}_changed?")
        if changed
          pinyin = Pinyin::parse eval("self.#{column}")
          eval("self.#{pinyin_column} = pinyin")
        end
      end
    end
  end

  def self.parse str
    pinyin = ""
    str.each_char do |ch|
      record = ChineseCharacter.find_by_utf8_code(ch)
      if record.nil?
        pinyin << ch
      else
        pinyin << record.pinyin
      end
    end
    pinyin
  end

  def self.init_db
    File.open('pinyin.txt') do |f|
      while str = f.gets
        str.match(/\$pinyintable\['(.*?)'\] = '(.*?)';/)
        ChineseCharacter.create(:utf8_code => $1, :pinyin => $2)
      end
    end
  end

end

ActiveRecord::Base.extend(Pinyin)
