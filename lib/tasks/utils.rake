namespace :utils do

  desc "往dir_path目录下的file_name里的image增加timestamp, 如果该file是文件夹，那递归对该目录下所有文件执行这个函数"
  task :add_timestamp_to_css_file, :file_name, :dir_path do |t, args|
    file_name = args[:file_name]
    dir_path = args[:dir_path]
    path = File.join(dir_path, file_name)
      puts "path=#{path}"
    if File.directory? path
        Dir.new(path).each do |f|
          Rake.application.invoke_task("utils:add_timestamp_to_css_file[#{f}, #{path}]")
        end
      else
        puts path
      end 
  end

  desc "修改application所有的css文件"
  task :add_timestamp_to_css_files => :environment do
    Rake.application.invoke_task("utils:add_timestamp_to_css_file[stylesheets, public]")
    #Rake::Task[:utils][:add_timestamp_to_css_file].invoke('', 'public/stylesheets') 
  end

end
