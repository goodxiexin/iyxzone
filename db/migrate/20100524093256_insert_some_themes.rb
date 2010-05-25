class InsertSomeThemes < ActiveRecord::Migration
  def self.up
    ["aion", "dnf", "dota", "popkart", "wenxin"].each do |theme|
      Skin.find_or_create(:name => theme, :css => theme, 
                          :thumbnail => "#{theme}.png")
    end
  end

  def self.down
  end
end
