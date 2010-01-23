class Boss < ActiveRecord::Base
	belongs_to :game
	belongs_to :guild
	has_many :gears
end
