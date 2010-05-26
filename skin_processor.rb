require 'fileutils'
class SkinStuff
	@@public_dir = "public"
	@@theme_dir = "."

	def initialize()
		if ARGV.size == 0
			puts "no argument: use PUBLIC=./public THEME_DIR='.'"
			@public_dir = @@public_dir
			@theme_dir = @@theme_dir
		elsif ARGV.size == 2
			@public_dir = ARGV[0]
			@theme_dir = ARGV[1]
		else
			error "USE runfile PUBLIC_DIR THEME_DIR"
		end
		
	end

	def do_stuff
		Dir.chdir(@theme_dir)
		skin_list = Dir["#{@theme_dir}/*"].select{ |dir| !(/\/public$/ =~ dir)}
		skin_list = skin_list.select{|d| File.directory?(d)}
		puts skin_list.inspect
		skin_list.each do |game|
			game.gsub!('./', '')
			find_or_create_dir(game)		
			do_css(game)
			do_image(game)
		end
	end

	def do_image(game)
		game_images = Dir["#{@theme_dir}/#{game}/images/*"]
		FileUtils.copy(game_images, @public_dir +"/images/themes/"+game)
	end

	def do_css(game)
		game_dir = Dir.pwd + '/' + game 	
		css_list = Dir[game_dir+ '/*.css']
		from_css = guess_css_name(css_list,game)
		from_css = update_css(from_css, game)
		show from_css
		dest_css = @public_dir+"/stylesheets/themes/#{game}/#{game}.css"	
		FileUtils.copy(from_css, dest_css, :verbose => true)
	end

	def update_css(css,game)
		origin_file = open(css, 'r')
		updated_file = open(css+'.new', 'w')
		origin_file.each do |str|
			str.gsub!('(images/', "(/images/themes/#{game}/")
			updated_file.write(str)
		end
		origin_file.close
		updated_file.close
		return css+'.new'
	end	

	def find_or_create_dir(game)
		unless File.directory?(@public_dir+'/stylesheets')
			Dir.mkdir(@public_dir+'/stylesheets')
		end
		unless File.directory?(@public_dir+'/stylesheets/themes')
			Dir.mkdir(@public_dir+'/stylesheets/themes')
		end
		unless File.directory?(@public_dir+"/stylesheets/themes/#{game}")
			Dir.mkdir(@public_dir+"/stylesheets/themes/#{game}")
		end
		unless File.directory?(@public_dir+'/images')
			Dir.mkdir(@public_dir+'/images')
		end
		unless File.directory?(@public_dir+'/images/themes')
			Dir.mkdir(@public_dir+'/images/themes')
		end
		unless File.directory?(@public_dir+"/images/themes/#{game}")
			Dir.mkdir(@public_dir+"/images/themes/#{game}")
		end
	end


	def guess_css_name(css_list, game)
		files = css_list.grep(/#{game}.css$/)
		if files.size > 0
			return files.first
		end
		files = css_list.grep(/style\.css$/)
		if files.size > 0
			return files.first
		end
		
		error("cant find css file in dir #{game}")
	end

	def show(str)
		$stderr.puts str
	end

	def error(str)
		$stderr.puts str
		$stderr.puts "exit!"
		exit
	end

end

s= SkinStuff.new
s.do_stuff
