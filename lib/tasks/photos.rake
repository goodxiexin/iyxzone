namespace :photos do

  task :regenerate_thumbnail => :environment do
    puts "====================== Avatar ==========================="
    Avatar.match(:parent_id => nil).all.each do |a|
      puts "id: #{a.id}, change #{a.public_filename}"
      a.thumbnails.destroy
      a.save
    end

    puts "====================== PersonalPhoto ==========================="
    PersonalPhoto.match(:parent_id => nil).all.each do |a|
      puts "id: #{a.id}, change #{a.public_filename}"
      a.thumbnails.destroy
      a.save
    end

    puts "====================== EventPhoto ==========================="
    EventPhoto.match(:parent_id => nil).all.each do |a|
      puts "id: #{a.id}, change #{a.public_filename}"
      a.thumbnails.destroy
      a.save
    end

    puts "====================== GuildPhoto ==========================="
    GuildPhoto.match(:parent_id => nil).all.each do |a|
      puts "id: #{a.id}, change #{a.public_filename}"
      a.thumbnails.destroy
      a.save
    end

    puts "====================== NewsPicture ==========================="
    NewsPicture.match(:parent_id => nil).all.each do |a|
      puts "id: #{a.id}, change #{a.public_filename}"
      a.thumbnails.destroy
      a.save
    end
  end

end
