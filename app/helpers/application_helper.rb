# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def avatar_path user, size="medium"
    if user.avatar.blank?
      "default_#{user.gender}_#{size}.png"
    else
      user.avatar.public_filename(size)
    end
  end

  def avatar_image(user, opts={})
    size = opts.delete(:size) || "medium"
    if user.avatar.blank?
      image_tag "default_#{user.gender}_#{size}.png", opts
    else
      image_tag user.avatar.public_filename(size), opts
    end
  end

	def game_image(game_name, opts={})
    size = opts.delete(:size)
		if FileTest.exist?(RAILS_ROOT + "/public/images/gamepic/#{game_name}.gif")
      file_name = size.blank? ? "#{game_name}.gif" : "#{game_name}_#{size}.gif"
			image_tag "/images/gamepic/#{file_name}", opts
		else
      file_name = size.blank? ? "default.gif" : "default_medium.gif"
			image_tag "/images/gamepic/#{file_name}", opts
		end
	end

  def avatar(user, img_opts={}, a_opts={})
		size = img_opts.delete(:size) || "medium"
    a_opts.merge!({:popup => true})
    if user.avatar.blank?
      link_to image_tag("default_#{user.gender}_#{size}.png", img_opts), profile_url(user.profile), a_opts
    else
      link_to image_tag(user.avatar.public_filename(size), img_opts), profile_url(user.profile), a_opts
    end
  end

  def profile_link(user, opts={})
    link_to user.login, profile_url(user.profile), opts
  end

  def validation_image
    "<img src='/application/new_validation_image' onclick='alert(\"begin\");this.src=\"/application/new_validation_image\";alert(\"done\");' />"
  end

  def ftime time
    time.strftime("%Y-%m-%d %H:%M") unless time.blank?
  end

  def ftime2 time
    time.strftime("%Y-%m-%d") unless time.blank?
  end

  def ftime3 time
    time.strftime("%m-%d") unless time.blank?
  end

  def ftime4 time
    time.strftime("%H: %M") unless time.blank?
  end

  def gender_select_tag obj
    select_tag "#{obj.class.to_s.underscore}[gender]", options_for_select([['男', 'male'], ['女', 'female']], obj.gender) 
  end
  
  def privilege_select_tag object, opts={}
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友及玩相同游戏的朋友', 2], ['好友', 3], ['自己', 4]], eval("@#{object}.privilege")), opts 
  end

  def privacy_select_tag obj, field
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['好友及玩相同游戏的朋友', 2], ['好友', 3]], eval("@#{obj}.#{field}"))
  end

  def friend_privacy_select_tag obj, field
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['玩相同游戏的朋友', 2]], eval("@#{obj}.#{field}"))
  end

  def poll_privilege_select_tag object
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友', 2]], eval("@#{object}.privilege"))
  end

  def event_privilege_select_tag object
    poll_privilege_select_tag object
  end

  def get_subject(user)
    if(current_user == user)
      "我"
    else
      if user.gender == 'male'
        "他"
      else
        "她"
      end
    end
  end

  def album_cover_image album, opts={}
    size = opts.delete(:size) || 'large'
    if album.photos_count == 0
			if album.is_a? GuildAlbum
				image_tag "default_guild_#{size}.png", opts
			elsif album.is_a? EventAlbum
				image_tag "default_event_#{size}.png", opts
			else
				image_tag "default_cover_#{size}.png", opts
			end
    else
      cover = album.cover_id.nil? ? album.photos.first : album.cover
      image_tag cover.public_filename(size), opts
    end
  end

  def album_cover(album, opts={})
		size = opts.delete(:size) || 'large'
    if album.photos_count == 0
			if album.is_a? GuildAlbum
				link_to image_tag("default_guild_#{size}.png", opts), eval("#{album.class.to_s.underscore}_url(album, :format => 'html')")
			elsif album.is_a? EventAlbum
				link_to image_tag("default_event_#{size}.png", opts), eval("#{album.class.to_s.underscore}_url(album, :format => 'html')")
			else
				link_to image_tag("default_cover_#{size}.png", opts), eval("#{album.class.to_s.underscore}_url(album, :format => 'html')")
			end
    else
      cover = album.cover_id.nil? ? album.photos.first : album.cover
      link_to image_tag(cover.public_filename(size), opts), eval("#{album.class.to_s.underscore}_url(album, :format => 'html')")
    end
  end

  def album_link album, opts={}
    link_to (truncate h(album.title), :length => 20), eval("#{album.class.name.underscore}_url(album, :format => 'html')"), opts
  end

  def photo_link(photo, opts={})
		size = opts.delete(:size) || "large"
    link_to (image_tag photo.public_filename(size), opts), eval("#{photo.class.name.underscore}_url(photo)")
  end

  # 这个dig_link是有图标的那个
  def icon_dig_link diggable
		dig_html = "<div class='evaluate'>"
		if diggable.digged_by? current_user
		  dig_html += "<span id='dig_#{diggable.class.name.underscore}_#{diggable.id}' class='dug'>#{diggable.digs_count}</span><a href='javascript: void(0)'>赞</a>"
		else
			dig_html += "<span id='dig_#{diggable.class.name.underscore}_#{diggable.id}'>#{diggable.digs_count}</span>"
		  dig_html += link_to_remote '赞', :url => digs_url("dig[diggable_type]" => diggable.class.base_class.to_s, "dig[diggable_id]" => diggable), :html => {:id => "digging_#{diggable.class.name.underscore}_#{diggable.id}"}, :loading => "Iyxzone.changeCursor('wait')", :complete => "Iyxzone.changeCursor('default')"
		end
		dig_html += "</div>"
    dig_html
  end

  def text_dig_link diggable, html_opts={}
    dig_html = link_to_remote '赞', :url => digs_url("dig[diggable_type]" => diggable.class.base_class.to_s, "dig[diggable_id]" => diggable, :at => 'show'), :html => {:id => "digging_#{diggable.class.to_s.underscore}_#{diggable.id}"}.merge(html_opts), :loading => "Iyxzone.changeCursor('wait')", :complete => "Iyxzone.changeCursor('default')"
    dig_html += "(<span id='dig_#{diggable.class.to_s.underscore}_#{diggable.id}' class='gray'>#{diggable.digs_count}</span>人赞过)"
    dig_html
  end

  def blog_content blog, opts={}
    if blog.content_abstract.length > opts[:length]
      (truncate blog.content_abstract, opts) + (link_to '查看全文 >>', blog_url(blog))
    else
      truncate blog.content_abstract, opts
    end
  end

  def news_content news, opts={}
    if news.data_abstract.length > opts[:length]
      (truncate news.data_abstract, opts) + (link_to '查看全文 >>', news_url(news))
    else
      truncate news.data_abstract, opts
    end
  end

  def news_link news, opts={}
    link_to (truncate (h news.title), :length => 40), news_url(news), opts
  end

  def blog_link blog, opts={}
    link_to (truncate (h blog.title), :length => 40), blog_url(blog), opts
  end

	def video_link video, opts={}
		link_to (truncate (h video.title), :length => 40), video_url(video), opts
	end

	def video_thumbnail video, opts={}
    temping = video.thumbnail_url.blank? ? "/images/photo/video01.png" : video.thumbnail_url
		image_tag temping, {:size => "120x90", :onclick => "Iyxzone.Video.play(#{video.id}, '#{video.embed_html}');"}.merge(opts)
	end

  def video_thumbnail_link video, opts={}
    temping = video.thumbnail_url.blank? ? "/images/photo/video01.png" : video.thumbnail_url
    link_to (image_tag temping, :size => "120x90", :class => "imgbox01"), video_url(video), opts
  end

  def game_link game, opts={}
    link_to h(game.name), game_url(game), opts
  end

  def event_link event, opts={}
    link_to (truncate h(event.title), :length => 40), event_url(event), opts
  end

	def poll_link poll, opts={}
		link_to (truncate h(poll.name), :length => 40), poll_url(poll), opts
	end

	def guild_link guild, opts={}
		link_to (truncate h(guild.name), :length => 40), guild_url(guild), opts
	end

	def forum_link forum, opts={}
		link_to (truncate h(forum.name), :length => 40), forum_url(forum), opts
	end

	def topic_link topic, opts={}
		link_to (truncate h(topic.subject), :length => 40), forum_topic_posts_url(topic.forum, topic), opts
	end

	def mail_link mail
		if mail.recipient == current_user # in recv box
			if mail.read_by_recipient
				link_to h(mail.title), mail_url(mail, :type => 1), :id => "mail_#{mail.id}_title"
			else
				link_to "#{h mail.title}", mail_url(mail, :type => 1), :id => "mail_#{mail.id}_title", :style => "font-weight: bold"
			end
		else # in sent box
			link_to h(mail.title), mail_url(mail, :type => 0), :id => "mail_#{mail.id}_title"
		end
	end

	def mail_select_tag
    select_tag 'select', options_for_select([['---', '^_^'], ['全部选中','all'], ['选读过的', 'read'], ['选没读的', 'unread'], ['取消全选', 'none']], "---"), :onchange => "Iyxzone.Mail.Manager.onDropdownChange()"
  end

	def button_submit text
		"<button type='submit'>#{text}</button>"
	end

	def button_to_function(name, *args, &block) 
    html_options = args.extract_options!.symbolize_keys

    function = block_given? ? update_page(&block) : args[0] || ''
    html_options[:onclick] = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function};"

    content_tag(:button, name, html_options)
	end

	def server_location server
    if server.game.no_areas
			"#{game_link server.game}, #{server.name}"
		else
			"#{game_link server.game}, #{server.area.name}, #{server.name}"
		end
	end

  def advanced_collection_select object, method, collection, value_method, text_method, options={}, html_options={}, extra_attributes={}
    html_code = "<select>";
    collection.each do |c|
      value = eval("c.#{value_method}")
      text = eval("c.#{text_method}")
      html_code += "<option value='#{value}' "
      extra_attributes.each do |k, v|
        val = eval("c.#{v}")
        html_code += "#{k}='#{val}' "
      end
      html_code += ">#{text}</option>"
    end
    html_code += "</select>"
    return html_code
  end

  def gender user
    if user.gender == 'male' 
      "男"
    else
      "女"
    end
  end

  def time_ago_in_chinese from_time
    e = Time.now - from_time
    if e >= 0 and e < 30
      "不到1分钟前"
    elsif e >= 30 and e < 90
      "1分钟前"
    elsif e >= 90 and e < 2670
      min = e / 60
      "#{min.to_i}分钟前"
    elsif e >= 1470 and e < 5370
      "大约一小时前"
    elsif e >= 5370 and e < 86370
      hour = e / 3600
      "#{hour.to_i}小时前"
    elsif e >= 86370 and e < 172770
      "1天前"
    elsif e >= 172770 and e < 2591970
      day = e / (3600 * 24)
      "#{day.to_i}天前"
    else
      "#{1}个月前"
    end    
  end

  def resize_image photo, opts={}
    if photo.width < 500
      image_tag photo.public_filename, opts
    else
      width = 500
      height = photo.height * 500 / photo.width
      image_tag photo.public_filename, opts.merge({:width => width, :height => height})
    end
  end

  def integer_array_for_javascript array
    if array.nil?
      "[]"
    else
      "[" + array.join(',') + "]"
    end
  end

  def skin_image_tag skin, img_opts={}
    link_to (image_tag "themes/#{skin.name}/#{skin.thumbnail}", {:alt => skin.name}.merge(img_opts)), skin_url(skin)
  end

  # this function might be broken if rails gets updated
  def onload_javascript_tag(content_or_options_with_block = nil, html_options = {}, &block)
    content =
      if block_given?
        html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        capture(&block)
      else
        content_or_options_with_block
      end

    tag = content_tag(:script, "document.observe('dom:loaded', function(){#{javascript_cdata_section(content)}});", html_options.merge(:type => Mime::JS))

    if block_called_from_erb?(block)
      concat(tag)
    else
      tag
    end
  end

	def copyright
	  "<p>Copyright &copy; 2010-2010 MingZen. All Rights Reserved</p> <p><a href='#'>鸣禅公司 版权所有</a></p>"
	end

  def sharing_reason sharing, opts={}
    reason = sharing.reason.blank? ? '。。。哥笑而不语。。。' : sharing.reason
    class_name = opts[:class] || 'con'
    simple_format "<span class='quote-start'></span>#{h reason}<span class='quote-end'></span>", :class => class_name
  end

  def game_infos
    Game.find(:all, :order => "pinyin ASC").map {|g| {:id => g.id, :name => g.name, :pinyin => g.pinyin}}.to_json
  end

  def album_infos
    current_user.all_albums.map {|a| {:id => a.id, :title => a.title, :type => a.class.name.underscore}}.to_json
  end

  # 系统默认的中间的p标签也会加上html_option，这是我不想要的
  def simple_format(text, html_options={})
    start_tag = tag('p', html_options, true)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")
    text.gsub!(/\n/, "<br/>")
    text.insert 0, start_tag
    text << "</p>"
  end

  def news_type news
    if news.news_type == 'text'
      "文字新闻"
    elsif news.news_type == 'picture'
      "图片新闻"
    elsif news.news_type == 'video'
      "视频新闻"
    end
  end
	
	def get_application
		uri = request.request_uri
		case uri
		when /blog/
			return "日志" 
		when /video/
			return "视频"
		when /event/
			return "活动"
		when /poll/
			return "投票"
		when /guild/
			return "公会"
		when /share/
			return "分享"
		end
	end

	def application_link
	  name = get_application
		app = Application.find(:first, :conditions => "name = '#{name}'")
    if !app.blank?
		  link_to "", application_url(app) , :class=>"icon-movie", :alt => "操作视频"
    end
	end

	def application_show
	  name = get_application
		app = Application.find(:first, :conditions => "name = '#{name}'")
		app.about if !app.blank?
	end

  def verify_link resource, opts={}
    link_to_remote '通过', :url => eval("verify_admin_#{resource.class.name.underscore}_url(resource)"), :loading => "Iyxzone.changeCursor('wait')", :complete => "Iyxzone.changeCursor('default');", :method => :put, :html => {:class => 'right'}
  end

  def unverify_link resource, opts={}
    link_to_remote '屏蔽', :url => eval("unverify_admin_#{resource.class.name.underscore}_url(resource)"), :loading => "Iyxzone.changeCursor('wait')", :complete => "Iyxzone.changeCursor('default');", :method => :put, :html => {:class => 'right'}
  end

end
