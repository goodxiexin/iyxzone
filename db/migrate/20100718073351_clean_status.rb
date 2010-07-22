class CleanStatus < ActiveRecord::Migration
  def self.up
=begin
    Status.all.each do |s|
      MiniBlog.create :poster => s.poster, :content => s.content
    end
    Status.destroy_all
    drop_table :statuses 
=end
  end

  def self.down
  end
end
