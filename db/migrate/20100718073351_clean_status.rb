class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => "User"

  acts_as_commentable

  acts_as_resource_feeds :recipients => lambda {|status| status.poster}

end

class CleanStatus < ActiveRecord::Migration

  def self.up
    # 必须有status.rb才能删除
    Status.all.each do |s|
      MiniBlog.create :poster => s.poster, :content => s.content
    end
    Status.destroy_all
    drop_table :statuses 
  end

  def self.down
  end
end
