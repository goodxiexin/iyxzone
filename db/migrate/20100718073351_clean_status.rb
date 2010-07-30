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

    puts "去掉设置里的状态设置"
    app = Application.find_by_name("状态")
    app.destroy if app
    User.update_all("mail_setting=#{MailSetting.default} and application_setting=#{ApplicationSetting.default}")

    # 删除status
    Comment.delete_all(:commentable_type => "Status")
    FeedDelivery.delete_all(:item_type => "Status")
    Status.delete_all
    remove_column :users, :statuses_count
    drop_table :statuses 
  end

  def self.down
  end
end
