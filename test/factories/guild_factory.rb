class GuildFactory

  def self.create cond={}
    cond.merge!({:character_id => GameCharacterFactory.create.id}) if cond[:character_id].blank?
    Factory.create :guild, cond
  end

end
