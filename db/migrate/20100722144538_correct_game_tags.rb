class CorrectGameTags < ActiveRecord::Migration
  def self.up
d = Dir.new('db/migrate')
d.each do |fname|
  if fname != '.' and fname != '..'
    f = File.open("db/migrate/#{fname}", "r")
    while str = f.gets
      if str =~ /game(\d+)\.tag_list \= \"(.+)\"/
        game_id = $1
        game_tags = $2
        puts "game_id: #{game_id}, tags: #{game_tags}, real_game_id: #{Gameswithhole.find_by_txtid(game_id).sqlid}"
        game = Game.find Gameswithhole.find_by_txtid($1).sqlid
        tag = Tag.game_tags.find_by_name(game.name)
        if tag
          puts "delete tag: #{tag.name}"
          tag.destroy
        end
        game.tag_list = $2
        game.save
      end
    end
  end
end
  end

  def self.down
  end
end
