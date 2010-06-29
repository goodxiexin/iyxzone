class MiniBlogFactory

  def self.create_text opts={}
    if opts[:poster].nil?
      opts[:poster] = UserFactory.create
    end

    Factory.create :mini_blog, {:category => MiniBlog::Category[0]}.merge(opts)
  end

  def self.create_image opts={}
    if opts[:poster].nil?
      opts[:poster] = UserFactory.create
    end

    if opts[:mini_image_id].nil?
      opts[:mini_image_id] = PhotoFactory.create(:type => 'MiniImage').id
    end

    Factory.create :mini_blog, {:category => MiniBlog::Category[1]}.merge(opts)
  end

  def self.create_video opts={}
    if opts[:poster].nil?
      opts[:poster] = UserFactory.create
    end

    if opts[:mini_video_id].nil?
      opts[:mini_video_id] = MiniVideo.create :video_url => 'http://v.youku.com/v_show/id_XMTg1MzY0Njcy.html'
    end

    Factory.create :mini_blog, {:category => MiniBlog::Category[2]}.merge(opts)
  end

  def self.create_music
  end

end
