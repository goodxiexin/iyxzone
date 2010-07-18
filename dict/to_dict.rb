def to_dict dir
	Dir.new(dir).each do |f|
		if f =~ /.+\.txt/
			from_file_name = File.join(dir, f)
			from_file = File.open(from_file_name, "r")
			to_file_name = File.join(dir, f.gsub(/txt/, "dict"))
			to_file = File.open(to_file_name, "w")
			puts "添加 #{f}\n "
			while str=from_file.gets
				to_file.write "#{str[0..(str.length-2)]}\t1\tGAME\n"
			end
		end
	end
end

if ARGV[0] =~ /^\/.+/
	to_dict ARGV[0]
else
	to_dict File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
end
