class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string :name
      t.string :icon_class
      t.text :about
      t.integer :comments_count, :default => 0
      t.timestamps
    end
    Application.create(:name => '日志', :icon_class => 'app-log')
    Application.create(:name => '视频', :icon_class => 'app-video')
    Application.create(:name => '照片', :icon_class => 'app-photo')
    Application.create(:name => '投票', :icon_class => 'app-vote')
    Application.create(:name => '活动', :icon_class => 'app-ploy')
    Application.create(:name => '公会', :icon_class => 'app-cons')
    Application.create(:name => '分享', :icon_class => 'app-share')
  end

  def self.down
    drop_table :applications
  end
end
