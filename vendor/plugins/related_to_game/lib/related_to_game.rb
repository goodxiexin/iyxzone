module RelatedToGame

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def related_to_game opts={}
      
      has_many :game_resources, :as => :resource, :dependent => :destroy

      has_many :games, :through => :game_resources, :source => :game

			cattr_accessor :related_to_game_opts

			self.related_to_game_opts = opts

      after_save :save_relative_games

      include RelatedToGame::InstanceMethods

      extend RelatedToGame::SingletonMethods

    end

  end

  module SingletonMethods

  end

  module InstanceMethods

    def new_relative_games= ids
      @new_relative_game_ids = ids  
    end

    def del_relative_games= ids
      @del_relative_game_ids = ids
    end

    def new_relative_games
      @new_relative_game_ids
    end

    def del_relative_games
      @del_relative_game_ids
    end 

    def has_game? game 
      game_id = (game.is_a? Integer) ? game : game.id
      game_resources.find_by_game_id(game_id)
    end
  
  protected

    def save_relative_games
      unless @del_relative_game_ids.blank?
        game_resources.match(:game_id => @del_relative_game_ids).destroy_all
        @del_relative_game_ids = nil
      end

      unless @new_relative_game_ids.blank?
        @new_relative_game_ids.each { |id| game_resources.create(:game_id => id) }
        @new_relative_game_ids = nil
      end
    end
  
  end

end

ActiveRecord::Base.send(:include, RelatedToGame)

