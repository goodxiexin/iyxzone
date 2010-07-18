class CovertSharingToMiniBlogs < ActiveRecord::Migration
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

    Share.destroy_all

    Link.destroy_all

    drop_table :shares

    drop_table :sharings

    drop_table :links
  end

  def self.down
  end
end
