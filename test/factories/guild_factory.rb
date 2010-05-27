class GuildFactory

  def self.create cond={}
    if cond[:character_id].blank? or cond[:president_id].blank?
      character = GameCharacterFactory.create
      cond.merge!({:character_id => character.id, :president_id => character.user_id})
    end
    Factory.create :guild, cond
  end

end
