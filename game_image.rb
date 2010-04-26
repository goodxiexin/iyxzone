require 'rubygems'
require 'RMagick'
include Magick

dir = 'public/images/gamepic'

output_dir = 'public/images/gamepic'

Dir.new(dir).each do |f|
  unless f == '.' or f == '..'
    img = Image.read(File.join(dir, f)).first
    thumbnail = img.thumbnail(50, 70)
    g = "#{f.split('.').first}_medium.#{f.split('.').last}"
    thumbnail.write File.join(output_dir, g) 
    puts "generate gif medium #{g} thumbnail of #{f}"
  end
end
