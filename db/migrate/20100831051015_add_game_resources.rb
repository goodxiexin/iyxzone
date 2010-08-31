class AddGameResources < ActiveRecord::Migration
  def self.up
    puts "convert blog"
    Blog.all.each do |b|
      b.new_relative_games = [b.game_id]
      b.save  
    end
    remove_column :blogs, :game_id

    puts "convert video"
    Video.all.each do |v|
      v.new_relative_games = [v.game_id]
      v.save  
    end
    remove_column :videos, :game_id

    puts "convert poll"
    Poll.all.each do |p|
      p.new_relative_games = [p.game_id]
      p.save  
    end
    remove_column :polls, :game_id

    puts "convert personal album"
    PersonalAlbum.all.each do |p|
      p.new_relative_games = [p.game_id]
      p.save  
    end

    puts "convert event album"
    EventAlbum.all.each do |p|
      p.new_relative_games = [p.game_id]
      p.save  
    end

    puts "convert guild album"
    GuildAlbum.all.each do |p|
      p.new_relative_games = [p.game_id]
      p.save  
    end

    remove_column :albums, :game_id
    remove_column :photos, :game_id

    puts "convert news"
    News.all.each do |p|
      p.new_relative_games = [p.game_id]
      p.save  
    end
    remove_column :news, :game_id
  end

  def self.down
  end
end
