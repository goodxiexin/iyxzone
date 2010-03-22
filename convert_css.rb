require 'fileutils'

RAILS_ROOT = '/home/gaoxh04/iyxzone'

def correct_path file
  # otherwise it's a deadin
  return if File.basename(file) == '.' || File.basename(file) == '..'
  
  if File.directory? file
    Dir.new(file).each do |f|
      correct_path File.join(file, f)
    end
  else
    return unless file =~ /\.css$/
    source = ''
    File.open(file) {|f| source = f.read}
    source.gsub!(/url\(\.\.\/images/, "url(/images")
    File.open(file, 'w') {|f| f.write(source)}
  end
end

def add_timestamps file
  return if File.basename(file) == '.' || File.basename(file) == '..'

  if File.directory? file
    Dir.new(file).each do |f|
      add_timestamps File.join(file, f)
    end
  else
    return unless file =~ /\.css$/
    source = ''
    File.open(file) {|f| source = f.read }
    source.gsub!(/url\((['"]*)(.+)(['"]*)\)/) do
      open, fd, close = $1, $2, $3
      timestamp = ''
      if fd =~ /^\// # absolute path
        f = File.new("public" + fd)
      else # relative path
        f = File.new(File.join(File.dirname(file), fd))
      end
      timestamp = f.mtime.to_i.to_s

      if fd =~ /.\.(ico|css|js|gif|jpe?g|png)/
        "url(#{open}#{fd}?#{timestamp}#{close})"
      else
        "url(#{open}#{fd}#{close})"
      end
    end
    File.open(file, 'w') {|f| f.write(source) }
  end 
end

correct_path "public/stylesheets"

add_timestamps "public/stylesheets"
