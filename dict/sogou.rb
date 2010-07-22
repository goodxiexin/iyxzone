require 'open-uri'
require 'iconv'

def grab_category c_id, total_pages
	total_pages.times do |page|
		puts "==================== grab page #{page+1} =========================="
		f = open("http://pinyin.sogou.com/dict/list.php?c=#{c_id}&page=#{page+1}")
		f.read.scan(/\<h2\>\<a href=\"cell.php\?id=(\d+)\"\>(.+)\<\/a\>(\<img src=\"images\/ui\/tuijian\.gif" \/\>)?\<\/h2\>/).each do |a|
			grab_dict a[0], get_utf8_name(a[1])
		end
	end
end

def grab_dict id, name
	`wget http://pinyin.sogou.com/dict/download_txt.php?id=#{id} -o /dev/null`
	`iconv -f GB18030 -t UTF-8 download_txt.php?id=#{id} -o #{name}.txt`
	`rm download_txt.php?id=#{id}`
	puts "download #{name}.txt"	
end

def get_utf8_name gb_name
	gb_name.gsub! /[ |\r|\t|\/|\\|:|\*|\?|\"|\&amp\;|\`|\<|\>|\(|\)]+/, "-"
	Iconv.iconv("utf8", "gb18030", gb_name).first
rescue # if iconv fails
	gb_name
end


