
class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :share

  def shareable
    share.nil? ? nil : share.shareable
  end

  acts_as_commentable

end

class Link < ActiveRecord::Base

end

class Share < ActiveRecord::Base

  belongs_to :shareable, :polymorphic => true

end

class CleanSharing < ActiveRecord::Migration


  def self.up
    # 只转3类，其他的就不管了
    Sharing.all.each do |s|
      if s.shareable_type == 'Profile'
        puts "分享玩家: #{s.shareable.user.login}"
        MiniBlog.create :poster => s.poster, :content => "@#{s.shareable.user.login}"
      elsif s.shareable_type == 'Link'
        puts "link: #{s.shareable.url}"
        MiniBlog.create :poster => s.poster, :content => s.shareable.url
      elsif s.shareable_type == 'Video'
        puts "video: #{s.shareable.video_url}"
        MiniBlog.create :poster => s.poster, :content => s.shareable.video_url
      end
    end

    # 应用设置里的emit_sharing_feed和recv_sharing_feed
    puts "去掉设置里的分享设置"
    app = Application.find_by_name("分享")
    app.destroy if app
    User.update_all("mail_setting=#{MailSetting.default} and application_setting=#{ApplicationSetting.default}")

    puts "删除分享"
    remove_column :users, :sharings_count
    remove_column :news, :sharings_count
    
    Share.destroy_all

    Link.destroy_all

    drop_table :shares

    drop_table :sharings

    drop_table :links

  end

  def self.down
  end

end
