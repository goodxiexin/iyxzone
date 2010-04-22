require 'rubygems'
require 'RMagick'
include Magick

dir = 'public/images/origin_gamepic'
ratio = 0.625

output_dir = 'public/images/gamepic'

Dir.new(dir).each do |f|
  unless f == '.' or f == '..'
    img = Image.read(File.join(dir, f)).first
    thumbnail = img.thumbnail(100, 227*ratio)
    thumbnail.write File.join(output_dir, f) 
    thumbnail.write File.join(output_dir, f.gsub('jpg', 'gif'))
    puts "generate jpg, gif thumbnails of #{f}"
  end
end
