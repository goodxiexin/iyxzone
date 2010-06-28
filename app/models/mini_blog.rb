class MiniBlog < ActiveRecord::Base

  serialize :forwarder_ids, Array

  Category = ['text', 'picture', 'video', 'music']

  belongs_to :poster, :class_name => 'User'

  belongs_to :initiator, :class_name => 'User'

  has_many :mini_blog_topics

  has_many :mini_topics, :through => :mini_blog_topics, :source => :mini_topic

  has_one :image, :class_name => 'MiniBlogImage'

  def forwarders
    User.find(forwarder_ids)
  end

  def origin?
    initiator.blank?
  end

  def forward user, content
    if origin?
      MiniBlog.create :poster_id => user.id, :forwarder_ids => [], :content => content, :category => category, :initiator_id => poster_id
    else
      new_forwarder_ids = (forwarder_ids || []).push poster_id
      MiniBlog.create :poster_id => user.id, :forwarder_ids => new_forwarder_ids, :content => content, :category => category, :initiator_id => initiator_id 
    end
  end

  validates_presence_of :poster_id

  validates_size_of :content, :within => 0..140

  validates_inclusion_of :category, :in => Category

  after_save :abstract_topics

protected

  def abstract_topics
    reg = /#([^#]+)#/
    matches = content.scan reg
    matches.each do |match|
      topic = MiniTopic.find_or_create :name => match.first
      MiniBlogTopic.create :mini_blog_id => self.id, :mini_topic_id => topic.id
    end
  end

end
