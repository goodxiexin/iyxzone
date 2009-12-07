class Topic < ActiveRecord::Base

  named_scope :tops, :conditions => ["top = true"]

  named_scope :normals, :conditions => ["top = false"]

  belongs_to :forum, :counter_cache => true

  belongs_to :poster, :class_name => 'User'

  has_many :posts, :dependent => :delete_all

  belongs_to :last_post, :class_name => 'Post'

  validate do |topic|
    topic.errors.add_to_base('标题不能为空') if topic.subject.blank?
    topic.errors.add_to_base('标题最长100个字符') if topic.subject.length > 100
    topic.errors.add_to_base('内容不能为空') if topic.content.blank?
    topic.errors.add_to_base('内容最长10000个字符') if topic.content.length > 10000
  end

end
