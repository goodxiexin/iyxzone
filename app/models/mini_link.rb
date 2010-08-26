require 'all_your_base'
require 'all_your_base/are/belong_to_us'

class MiniLink < ActiveRecord::Base

  UrlReg = /#{SITE_URL}\/links\/\w+/

  def compressed_id
    id.to_base_62 #a-zA-Z0-9
  end

  def proxy_url
    "#{SITE_URL}\/links/#{compressed_id}"    
  end

  def is_video?
    !embed_html.blank? and !thumbnail_url.blank?
  end

  # http://www.17gaming.com/links/3K
  def self.find_by_proxy_url url
    self.find_by_id url.split('/').last.from_base_62
  end

  # 3K 
  def self.find_by_compressed_id compressed_id
    self.find_by_id compressed_id.from_base_62
  end

  validates_presence_of :url

  validates_uniqueness_of :url

  validate_on_create :check_if_video

protected

  def check_if_video
    unless url.blank?
      type = video_type(url)
      unless type.blank?
        video = type.new(url)
        self.embed_html = video.embed_html
        self.thumbnail_url = video.thumbnail_url
      end
    end
  end

  def video_type video_url
    return Youku if Youku.identify_url(video_url)
    return Tudou if Tudou.identify_url(video_url)
    return FiveSix if FiveSix.identify_url(video_url)
    return Ku6   if Ku6.identify_url(video_url)
  end

end
