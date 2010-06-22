class StatusFactory

  def self.create cond={}
    poster = Factory.create :user
    Factory.create :status, {:poster_id => poster.id}.merge(cond) 
  end
  
end
