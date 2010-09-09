def add_skin name, desc
	puts "start..."
  image_path = File.join(RAILS_ROOT, name, "images")
  style_path = File.join(RAILS_ROOT, name, "style.css")
  to_image_path = File.join(RAILS_ROOT, 'public', 'images', 'themes', name);
  to_style_path = File.join(RAILS_ROOT, 'public', 'stylesheets', 'themes', name);

  # copy image
  puts "copy image"
  `mkdir #{to_image_path}`
  `cp -r #{image_path}/* #{to_image_path}`
  # change style
  puts "correct image path of css"
  css = ''
  File.open(style_path) {|f| css = f.read} 
  css.gsub!(/url\(images/, "url(/images/themes/#{name}")
  File.open(style_path, 'w') {|f| f.write(css)}
  # copy style
  puts "copy css"
  `mkdir #{to_style_path}`
  `cp #{style_path} #{to_style_path}/#{name}.css`
  # create
  puts "create skin"
  Skin.create :name => desc, :directory => name, :css => name, :thumbnail => "#{name}.png", :privilege => 1, :category => "Profile" 
  
  puts "skin: #{name} done"
end
