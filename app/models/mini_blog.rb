class MiniBlog < ActiveRecord::Base

  serialize :nodes, Array

  serialize :forwarder_ids, Array

  belongs_to :poster, :polymorphic => true

  belongs_to :initiator, :polymorphic => true

  def poster= poster
    unless poster.blank?
      self.poster_id = poster.id
      self.poster_type = poster.class.name
    end
  end

  def initiator= initiator
    unless initiator.blank?
      self.initiator_id = initiator.id
      self.initiator_type = initiator.class.name
    end
  end

  def text_type?
    images_count == 0 and videos_count == 0
  end

  def image_type?
    images_count != 0
  end

  def video_type?
    videos_count != 0
  end

  def origin?
    initiator.blank?
  end

  def forward user, content
    if origin?
      MiniBlog.create :poster => user, :initiator => poster, :content => content, :forwarder_ids => []
    else
      new_forwarder_ids = forwarder_ids.push poster_id
      MiniBlog.create :poster => user, :initiator => initiator, :content => content, :forwarder_ids => new_forwarder_ids
    end
  end

  def forwarders
    # TODO: 为啥这样的顺序就不对了
    #User.find(forwarder_ids || [])
    (forwarder_ids || []).map {|id| User.find_by_id(id)}
  end 

  def mini_topics
    MiniTopic.find(nodes.select{|n| n[:type] == 'topic'}.map{|n| n[:topic_id]})
  end

  def mini_videos
  end

  def mini_links
    MiniLink.find(nodes.select{|n| n[:type] == 'link'}.map{|n| n[:link_id]})
  end

  def relative_users
    User.find(nodes.select{|n| n[:type] == 'ref'}.map{|n| n[:user_id]})
  end

  def mini_image_id= image_id
    @mini_image_id = image_id.to_i
  end

  before_create :parse_content

  validates_size_of :content, :within => 1..140

protected

  def update_mini_image
    unless @mini_image_id.blank?
      MiniImage.update_all("mini_blog_id = #{id}", {:id => @mini_image_id})
      increment :images_count
      @mini_image_id = nil
    end
  end

  def parse_content
    nodes = []
    MiniBlogParser.parse(content).each do |node|
      case node[:type]
      when 'text'
        nodes << {:type => 'text', :val => node[:val]}
      when 'topic'
        mini_topic = MiniTopic.find_or_create :name => node[:val]
        nodes << {:type => 'topic', :val => node[:val], :topic_id => mini_topic.id}
      when 'link'
        if node[:val] =~ MiniLink::UrlReg
          mini_link = MiniLink.find_by_compressed_id node[:val].split('/').last
        else
          mini_link = MiniLink.find_or_create :url => node[:val]
        end
        nodes << {:type => 'link', :val => mini_link.proxy_url, :link_id => mini_link.id}
      when 'ref'
        user = User.find_by_login node[:val]
        nodes << {:type => 'ref', :val => node[:val], :user_id => user.nil? ? nil : user.id}
      end
    end
    self.nodes = nodes 
  end

end
