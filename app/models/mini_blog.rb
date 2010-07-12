class MiniBlog < ActiveRecord::Base

  serialize :nodes, Array

  belongs_to :poster, :class_name => 'User'

  belongs_to :root, :class_name => 'MiniBlog'

  belongs_to :parent, :class_name => 'MiniBlog'

  has_many :children, :class_name => 'MiniBlog', :foreign_key => 'parent_id'

  named_scope :hot, :conditions => {:deleted => false}, :order => "forwards_count DESC, created_at DESC"
  
  named_scope :sexy, :conditions => {:deleted => false}, :order => "comments_count DESC, created_at DESC"

  named_scope :category, lambda {|type|
    if type == 'all'
      {:order => 'created_at DESC'}
    elsif type == 'original'
      {:order => 'created_at DESC', :conditions => {:root_id => nil, :parent_id => nil}}
    elsif type == 'text'
      {:order => 'created_at DESC', :conditions => {:videos_count => 0, :images_count => 0}}
    elsif type == 'video'
      {:order => 'created_at DESC', :conditions => "videos_count != 0"}
    elsif type == 'image'
      {:order => 'created_at DESC', :conditions => "images_count != 0"}
    end
  }

  acts_as_commentable :recipient_required => false, :order => 'created_at ASC'

  acts_as_random
 
  def text_type?
    images_count == 0 and videos_count == 0
  end

  def image_type?
    images_count != 0
  end

  def video_type?
    videos_count != 0
  end

  def original?
    root_id.nil? and parent_id.nil?
  end

  def forward user, content
    MiniBlog.create :poster => user, :parent_id => id, :root_id => (original? ? id : root_id), :content => content
  end

  has_one :mini_image

  def mini_topics
    nodes.select{|n| n[:type] == 'topic'}.map{|n| MiniTopic.find_by_name n[:name]}
  end

  def mini_videos
    mini_links.select {|l| l.is_video?}
  end

  def mini_links
    nodes.select{|n| n[:type] == 'link'}.map{|n| MiniLink.find_by_proxy_url n[:proxy_url]}
  end

  def relative_users
    nodes.select{|n| n[:type] == 'ref'}.map{|n| User.find_by_login n[:login]}
  end

  before_create :parse_content

  validate_on_create :content_length_is_valid

  alias_method 'real_destroy', 'destroy'
  
  def destroy
    if original? and forwards_count != 0
      update_attributes(:deleted => true)
    else
      real_destroy
    end
  end

  before_create :create_index

  before_update :update_index
  
  before_destroy :destroy_index

protected

  def create_index
    self.index_state = 0 # unindexed
  end

  def update_index
    if self.index_state == 1 # indexed in main
      self.index_state = 2 # updated in main index
      #info = FerretInfo.find_by_model_name 'MiniBlog'
      #info.modified_indexes.updated.create :doc_id => id
    end
  end

  def destroy_index
    if self.index_state == 1 # indexed in main
      info = FerretInfo.find_by_model_name 'MiniBlog'
      info.modified_indexes.deleted.create :doc_id => id
    end
  end

  def content_length_is_valid
    if content.blank?
      errors.add(:content, "不能为空")
    else
      content.gsub!(/[ |\r|\n|\t]+/, " ")
      if content.length > 140
        errors.add(:content, "太长")
      elsif content.length < 1
        errors.add(:content, "太短")
      end
    end
  end

  def parse_content
    nodes = []
    MiniBlogParser.parse(content).each do |node|
      case node[:type]
      when 'text'
        nodes << {:type => 'text', :val => node[:val]}
      when 'topic'
        MiniTopic.find_or_create :name => node[:val]
        nodes << {:type => 'topic', :name => node[:val]}
      when 'link'
        if node[:val] =~ MiniLink::UrlReg
          mini_link = MiniLink.find_by_proxy_url node[:val]
        else
          mini_link = MiniLink.find_or_create :url => node[:val]
        end
        increment :videos_count if !mini_link.blank? and mini_link.is_video?
        nodes << {:type => 'link', :proxy_url => mini_link.nil? ? node[:val] : mini_link.proxy_url}
      when 'ref'
        nodes << {:type => 'ref', :login => node[:val]}
      end
    end
    self.nodes = nodes 
  end

end
