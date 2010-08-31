class AddGameResources < ActiveRecord::Migration
  def self.up
=begin
    puts "convert blog"
    Blog.all.each do |b|
      b.new_relative_games = [b.game_id]
      b.save  
    end
    remove_column :blogs, :game_id
=end

    puts "convert video"
    Video.all.each do |v|
      v.new_relative_games = [v.game_id]
      v.save  
    end
    remove_column :videos, :game_id
  end

  def self.down
  end
end
