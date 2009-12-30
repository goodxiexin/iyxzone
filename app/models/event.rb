class Event < ActiveRecord::Base

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id'

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

	acts_as_commentable :order => 'created_at DESC'

	named_scope :hot, :conditions => ["start_time > ?", Time.now.to_s(:db)], :order => 'confirmed_count DESC'
	
	named_scope :recent, :conditions => ["start_time > ?", Time.now.to_s(:db)], :order => 'start_time DESC'

  has_many :participations, :dependent => :destroy

  has_many :invitations, :class_name => 'Participation', :conditions => {:status => 0}, :dependent => :destroy
  
  has_many :requests, :class_name => 'Participation', :conditions => {:status => [1,2]}, :dependent => :destroy

	with_options :through => :participations, :source => 'participant' do |event|

		event.has_many :invitees, :conditions => "participations.status = 0"

		event.has_many :requestors, :conditions => "participations.status = 1 OR participations.status = 2"

		event.has_many :confirmed_participants, :conditions => "participations.status = 3"

		event.has_many :maybe_participants, :conditions => "participations.status = 4"

		event.has_many :declined_participants, :conditions => "participations.status = 5"

		event.has_many :participants, :conditions => "participations.status = 3 or participations.status = 4 or participations.status = 5"

	end

	acts_as_resource_feeds

	searcher_column :title

  validate do |event|
    event.errors.add_to_base("标题不能为空") if event.title.blank?
    event.errors.add_to_base("标题太长，最长100个字符") if event.title and event.title.length > 100
    event.errors.add_to_base("描述不能为空") if event.description.blank?
    event.errors.add_to_base("描述最长10000个字符") if event.description and event.description.length > 10000
    event.errors.add_to_base("游戏类别不能为空") if event.game_id.blank?
    event.errors.add_to_base("游戏服务器不能为空") if event.game_server_id.blank?
    event.errors.add_to_base("游戏服务区不能为空") if !event.game.no_areas and event.game_area_id.blank?
    event.errors.add_to_base("开始时间不能为空") if event.start_time.blank?
    event.errors.add_to_base("开始时间不能比现在早") if event.start_time and event.start_time <= Time.now
    event.errors.add_to_base("结束时间不能为空") if event.end_time.blank?
    event.errors.add_to_base("结束时间不能比开始时间早") if event.end_time and event.end_time <= event.start_time 
  end

  # virtual attribute: past?
  def past
    start_time < Time.now
  end

	def participantable? user
		poster == user || privilege == 1 || (privilege == 2 and poster.has_friend? user)
	end
  
end
