class MiniBlog < ActiveRecord::Base

  serialize :forwarder_ids, Array

  Category = ['text', 'image', 'video', 'music']

  belongs_to :poster, :polymorphic => true

  belongs_to :initiator, :polymorphic => true

  has_many :mini_blog_topics

  has_many :mini_topics, :through => :mini_blog_topics, :source => :mini_topic

  has_one :mini_image

  has_one :mini_video

  named_scope :category, lambda {|name| {:conditions => {:category => name}}}

  named_scope :hot, :order => "forwards_count DESC"
  
  named_scope :sexy, :order => "comments_count DESC"

  # TODO：谁能删除
  acts_as_commentable :order => 'created_at DESC'

  # TODO: 转换后超过字数了阿
  escape_html :sanitize => :content
  
  acts_as_emotion_text :columns => [:content]

  attr_accessor :mini_image_id, :mini_video_id

  def forwarders
    User.find(forwarder_ids)
  end

  def origin?
    initiator.blank?
  end

  def poster= poster
    unless poster.nil?
      self.poster_id = poster.id
      self.poster_type = poster.class.name
    end
  end

  def initiator= initiator
    unless initiator.nil?
      self.initiator_id = initiator.id
      self.initiator_type = initiator.class.name
    end
  end

  def forward user, content
    self.raw_increment :forwards_count
    if origin?
      MiniBlog.create :poster => user, :forwarder_ids => [], :content => content, :category => category, :initiator => poster
    else
      new_forwarder_ids = (forwarder_ids || []).push poster_id
      MiniBlog.create :poster => user, :forwarder_ids => new_forwarder_ids, :content => content, :category => category, :initiator => initiator
    end
  end

  validates_presence_of :poster_id, :poster_type

  validates_size_of :content, :within => 0..140

  validates_inclusion_of :category, :in => Category

  after_create :abstract_topics

  before_create :abstract_links

  after_create :update_mini_image

  after_create :update_mini_video

protected

  def abstract_topics
    content.scan(/#([^#]+)#/).each do |match|
      topic = MiniTopic.find_or_create :name => match.first
      MiniBlogTopic.create :mini_blog_id => id, :mini_topic_id => topic.id
    end
  end

  def abstract_links
    content.gsub!(/(http:\/\/([a-zA-Z_0-9\-]+\.)+[a-zA-Z_0-9\-]+(\/[a-zA-Z_0-9\-%=&]+)?)/).each do |url|
      if url =~ /http:\/\/17gaming.com\/[\w]+/
        url
      else
        link = MiniLink.find_or_create :url => url
        "http://17gaming.com/links/#{link.compressed_id}"
      end
    end
  end

  def update_mini_image
    if !@mini_image_id.blank?
      MiniImage.update_all("mini_blog_id = #{id}", {:id => @mini_image_id})
    end
  end

  def update_mini_video
    if !@mini_video_id.blank?
      MiniVideo.update_all("mini_blog_id = #{id}", {:id => @mini_video_id})
    end
  end

end
