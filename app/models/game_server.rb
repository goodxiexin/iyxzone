class GameServer < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'servers_count'

  belongs_to :area, :class_name => 'GameArea', :counter_cache => 'servers_count'

	has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'server_id'

	has_many :users, :through => :characters, :uniq => true

end
