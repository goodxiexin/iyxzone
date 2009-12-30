class Gear < ActiveRecord::Base
	belongs_to :game
	belongs_to :boss
end
