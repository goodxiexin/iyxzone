class FanFactory

  def self.create fan, idol
    Fanship.create :fan_id => fan.id, :idol_id => idol.id
  end

end
