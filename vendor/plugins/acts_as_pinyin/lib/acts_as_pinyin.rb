# ActsAsPinyin
require 'rubygems'

module Pinyin

  def acts_as_pinyin options={}
    define_method("before_create") do
      options.each do |column, pinyin_column|
        str = eval("self.#{column}")
        pinyin = ""
        str.each_char do |ch|
          record = ChineseCharacter.find_by_utf8_code(ch)
          if record.nil?
            pinyin << ch
          else
            pinyin << record.pinyin
          end
        end
        eval("self.#{pinyin_column} = pinyin")
      end
    end
  end

end

ActiveRecord::Base.extend(Pinyin)
