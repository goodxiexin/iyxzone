File.open('pinyin_array.php') do |f|
  while str = f.gets
    str.match(/\$pinyintable\['(.*?)'\] = '(.*?)';/)
    puts "#{$1}: #{$2}"
  end
end
