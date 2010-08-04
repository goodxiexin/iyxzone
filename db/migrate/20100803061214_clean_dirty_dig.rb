class CleanDirtyDig < ActiveRecord::Migration
  def self.up
    Dig.all.select{|d| d.diggable.blank?}.each do |dig|
      dig.delete
    end
  end

  def self.down
  end
end
