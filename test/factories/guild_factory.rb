class GuildFactory

  def self.create cond={}
    if cond[:character_id].blank?
      character = GameCharacterFactory.create
      cond.merge!({:character_id => character.id})
    end
    Factory.create :guild, cond
  end

end
