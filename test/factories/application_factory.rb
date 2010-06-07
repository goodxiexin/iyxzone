class ApplicationFactory

  def self.create cond={}
    Factory.create :application, cond
  end

end
