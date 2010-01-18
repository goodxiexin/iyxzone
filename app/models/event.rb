class Event < ActiveRecord::Base

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

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

  acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, event, comment| event.poster == user}, 
                      :create_conditions => lambda {|user, event| event.has_participant?(user)}

	acts_as_resource_feeds

	searcher_column :title

  def has_participant? user
    !participations.find(:first, :conditions => {:status => [3,4,5], :participant_id => user.id}).blank?
  end

  def past
    start_time < Time.now
  end

  def requestable_by user
    privilege == 1 || (privilege == 2 and poster.has_friend? user)
  end

  def validate
    # check poster
    errors.add_to_base("没有作者") if poster_id.blank?

    # check title
    if title.blank?
      errors.add_to_base("标题不能为空")
    elsif title.length > 100
      errors.add_to_base("标题太长，最长100个字符")
    end

    # check description
    if description.blank? 
      errors.add_to_base("描述不能为空")
    elsif description.length > 10000
      errors.add_to_base("描述最长10000个字符")
    end

    # check game, game area, game server
    if game_id.blank?
      errors.add_to_base("游戏类别不能为空")
    else
      game = Game.find(:first, :conditions => {:id => game_id})
      if game.nil?
        errors.add_to_base("游戏不存在")
      elsif game.no_areas
        if !game_area_id.blank?
          errors.add_to_base("游戏服务区应该为空")
        elsif game_server_id.blank?
          errors.add_to_base("游戏服务器不能为空")
        elsif game.servers.find(:first, :conditions => {:id => game_server_id}).nil?
          errors.add_to_base("游戏服务器不存在或者不属于该游戏")
        end
      else
        area = game.areas.find(:first, :conditions => {:id => game_area_id})
        if area.nil?
          errors.add_to_base("游戏服务区不能为空")
        elsif game_server_id.blank?
          errors.add_to_base("游戏服务器不能为空")
        elsif area.servers.find(:first, :conditions => {:id => game_server_id}).nil?
          errors.add_to_base("游戏服务器不存在或者不属于该区域")
        end
      end
    end 

    # check start time
    if start_time.blank?
      errors.add_to_base("开始时间不能为空")
    elsif start_time <= Time.now 
      errors.add_to_base("开始时间不能比现在早")
    end

    # check end time
    if end_time.blank?
      errors.add_to_base("结束时间不能为空")
    elsif start_time and end_time <= start_time
      errors.add_to_base("结束时间不能比开始时间早")
    end
  end

end
