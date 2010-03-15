class TagMailer < ActionMailer::Base

  def blog_tag tag
    setup_email	tag
		subject			"17Gaming.com(一起游戏网) - #{tag.poster.login}在博客里标记了你"
		body				:tag => tag, :url => "#{SITE_URL}/blogs/#{tag.taggable_id}"
  end

  def video_tag tag
		setup_email tag
    subject     "17Gaming.com(一起游戏网) - #{tag.poster.login}在视频里标记了你"
    body        :tag => tag, :url => "#{SITE_URL}/videos/#{tag.taggable_id}"
	end

  def photo_tag tag
		setup_email tag
    subject     "17Gaming.com(一起游戏网) - #{tag.poster.login}在相册里圈了你"
    body        :tag => tag, :url => "#{SITE_URL}/#{tag.photo.class.to_s.underscore.pluralize}/#{tag.photo_id}"
  end

  def photo_tag_to_owner tag
    poster = tag.photo.album.poster
    recipients  poster.email
    from        SITE_MAIL
    sent_on     Time.now
    subject     "17Gaming.com(一起游戏网) - #{tag.poster.login}标记了你的相册"
    body        :tag => tag, :user => poster, :url => "#{SITE_URL}/#{tag.photo.class.to_s.underscore.pluralize}/#{tag.photo_id}"
	end

  def profile_tag tagging
    profile = tagging.taggable
    tag = tagging.tag
    poster = tagging.poster

    recipients  profile.user.email
    from        SITE_MAIL
    sent_on     Time.now
    subject     "17Gaming.com(一起游戏网) - #{poster.login} 对你的印象是: #{tag.name}"
    body        :tagging => tagging, :user => profile.user, :url => "#{SITE_URL}/profiles/#{profile.id}"
  end

protected

  def setup_email tag
		recipients	tag.tagged_user.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
