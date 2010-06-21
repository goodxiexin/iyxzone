class PokeFactory

  def self.create cond={}
    Factory.create :poke, cond
  end

end
