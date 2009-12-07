class GameArea < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'areas_count'

  has_many :servers, :class_name => 'GameServer', :foreign_key => 'area_id'  

	has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'server_id'

  has_many :users, :through => :characters, :uniq => true

end
