class Tag < ActiveRecord::Base

	has_many :taggings, :dependent => :delete_all

  DEFAULT_MALE_TAGS = ["成熟", "老实", "花心", "害羞", "无常", "无法形容", "宅男", "自信", "幽默", "小>盆友", "闷骚", "轻微猥琐", "怪叔叔", "风流倜傥", "传闻多", "实在", "大忙人"]

  DEFAULT_FEMALE_TAGS = ["冰雪聪明", "敏感", "卡哇伊", "耐心", "前卫", "精明", "活泼", "阳光", "风趣", "单纯", "天使", "辣", "简单", "魔鬼身材", "干练", "淑女", "清爽"] 
 
	named_scope :game_tags, :conditions => {:taggable_type => 'Game'}

	named_scope :profile_tags, :conditions => {:taggable_type => 'Profile'}
 
  acts_as_pinyin :name => "pinyin"

  searcher_column :pinyin, :name

  validates_size_of :name, :within => 1..15

  # defined in config/initializer/custom_validation.rb
  validates_bytes_of :name, :within => 1..30

  validates_inclusion_of :taggable_type, :in => ['Game', 'Profile']

  validates_uniqueness_of :name, :scope => :taggable_type, :if => "!name.blank? and !taggable_type.blank?"

end
