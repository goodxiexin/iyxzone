class ConvertStatusToMiniBlogs < ActiveRecord::Migration
  def self.up
    Status.all.each do |s|
      MiniBlog.create :poster => s.poster, :content => s.content
    end
    Status.destroy_all
    drop_table :statuses 
  end

  def self.down
  end
end
