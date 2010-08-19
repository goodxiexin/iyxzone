def add_promotion_skin name
  image_path = File.join(RAILS_ROOT, name, "images")
  style_path = File.join(RAILS_ROOT, name, "style.css")
  to_image_path = File.join(RAILS_ROOT, 'public', 'images', 'promotions', name);
  to_style_path = File.join(RAILS_ROOT, 'public', 'stylesheets', 'promotions', name);

  # copy image
  puts "copy image"
  `mkdir #{to_image_path}`
  `cp -r #{image_path}/* #{to_image_path}`
  # change style
  puts "correct image path of css"
  css = ''
  File.open(style_path) {|f| css = f.read} 
  css.gsub!(/url\(images/, "url(/images/promotions/#{name}")
  File.open(style_path, 'w') {|f| f.write(css)}
  # copy style
  puts "copy css"
  `mkdir #{to_style_path}`
  `cp #{style_path} #{to_style_path}/#{name}.css`
  # create
  puts "create skin"
  
  puts "skin: #{name} done"
end
