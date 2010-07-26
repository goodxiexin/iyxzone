class CleanStatus < ActiveRecord::Migration
  def self.up
    # 必须有status.rb才能删除
    Status.all.each do |s|
      MiniBlog.create :poster => s.poster, :content => s.content
    end
    Status.destroy_all
    drop_table :statuses 
    if File.exist? 'app/models/status.rb'
      File.delete 'app/models/status.rb'
    end
  end

  def self.down
  end
end
