class EventFactory

  def self.create cond={}
    if cond[:character_id].blank?
      character = GameCharacterFactory.create
      cond.merge!({:character_id => character.id, :poster_id => character.user_id})
    end
 
    Factory.create :event, cond
  end

end
