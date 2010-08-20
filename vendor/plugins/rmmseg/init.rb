require File.dirname(__FILE__) + '/lib/rmmseg.rb'

# load dictionary
# 一般类的单字和多词
=begin
RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "chars.dict"), :chars
RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "words.dict"), :words
# 游戏
Dir.new(File.join(RAILS_ROOT, "dict", "game")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "game", f), :words
  end
end

# 体育休闲
Dir.new(File.join(RAILS_ROOT, "dict", "sports")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "sports", f), :words
  end
end

=begin
# 娱乐
Dir.new(File.join(RAILS_ROOT, "dict", "entertainment")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "entertainment", f), :words
  end
end

# 生活
Dir.new(File.join(RAILS_ROOT, "dict", "life")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "life", f), :words
  end
end

# 科学
Dir.new(File.join(RAILS_ROOT, "dict", "science")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "science", f), :words
  end
end

# 艺术
Dir.new(File.join(RAILS_ROOT, "dict", "art")).each do |f|
  if f =~ /.+\.dict/
    RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "art", f), :words
  end
end
=end

# 其他，这里包括一些17gaming.com的词条，还有其他上面不包括的词条
RMMSeg::Dictionary.add_dictionary File.join(RAILS_ROOT, "dict", "other.dict"), :words
RMMSeg::Dictionary.init
RMMSeg::Dictionary.load_dictionaries
