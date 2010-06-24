class Tag < ActiveRecord::Base

	has_many :taggings, :dependent => :delete_all

	named_scope :game_tags, :conditions => {:taggable_type => 'Game'}

	named_scope :profile_tags, :conditions => {:taggable_type => 'Profile'}
 
  acts_as_pinyin :name => "pinyin"

  searcher_column :pinyin, :name

  validates_size_of :name, :within => 1..15, :too_short => "最短1个字符", :too_long => "最长15个字符"

  # defined in config/initializer/custom_validation.rb
  validates_bytes_of :name, :within => 1..30, :too_short => "最短1个字节", :too_long => "最长30个字节"

  validates_inclusion_of :taggable_type, :in => ['Game', 'Profile']

  validates_uniqueness_of :name, :scope => :taggable_type, :if => "!name.blank? and !taggable_type.blank?"

end
