require 'fileutils'
RAILS_ROOT = '/home/gaoxh04/iyxzone'
def add_timestamps_to_css_file file_name, dir_path
  return if file_name == '.' or file_name == '..'
  return if file_name.include? '?'
  path = File.join(dir_path, file_name)
  if File.directory? path 
    Dir.new(path).each do |f|
      add_timestamps_to_css_file f, path
    end
  else
    puts path
    source = ''
    File.open(path) {|f| source = f.read }
    source.gsub!(/url\((['"]*)(.+)(['"]*)\)/) do
      open, file, close = $1, $2, $3
      #css_dir = "public/stylesheets"
      timestamp = ''
      FileUtils.cd("public/stylesheets") do
        if file =~ /^\// # absolute path
          f = File.new("#{RAILS_ROOT}/public" + file)
        else # relative path
          f = File.new("#{RAILS_ROOT}/#{File.join(dir_path, file)}")
        end
        timestamp = f.mtime.to_i.to_s
      end

      if file =~ /.\.(ico|css|js|gif|jpe?g|png)/
        "url(#{open}#{file}?#{timestamp}#{close})"
      else
        "url(#{open}#{file}#{close})"
      end
    end
    File.open("#{dir_path}/#{file_name}", 'w') {|f| f.write(source) }
  end 
end

add_timestamps_to_css_file '', 'public/stylesheets'
