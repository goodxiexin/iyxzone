class Event < ActiveRecord::Base

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  belongs_to :poster, :class_name => 'User'

  belongs_to :poster_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

  belongs_to :guild

	named_scope :hot, :conditions => {:expired => 0}, :order => 'confirmed_count DESC'
	
	named_scope :recent, :conditions => {:expired => 0}, :order => 'start_time DESC'

  has_many :participations, :dependent => :delete_all # we dont want to trigger participation destroy callback here, it's slow.

  has_many :confirmed_participations, :class_name => 'Participation', :conditions => {:status => Participation::Confirmed}

  has_many :maybe_participations, :class_name => 'Participation', :conditions => {:status => Participation::Maybe}

  has_many :invitations, :class_name => 'Participation', :conditions => {:status => Participation::Invitation}
  
  has_many :requests, :class_name => 'Participation', :conditions => {:status => Participation::Request}

	with_options :source => 'participant', :uniq => true do |event|

		event.has_many :invitees, :through => :invitations

		event.has_many :requestors, :through => :requests

		event.has_many :confirmed_participants, :through => :confirmed_participations

		event.has_many :maybe_participants, :through => :maybe_participations

		event.has_many :participants, :through => :participations, :conditions => "participations.status = 3 or participations.status = 4"

	end

  with_options :source => 'character' do |event|

    event.has_many :invite_characters, :through => :invitations

    event.has_many :request_characters, :through => :requests

    event.has_many :confirmed_characters, :through => :confirmed_participations

    event.has_many :maybe_characters, :through => :maybe_participations

    event.has_many :characters, :through => :participations, :conditions => "participations.status = 3 or participations.status = 4"

    event.has_many :all_characters, :through => :participations

  end

  acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, event, comment| event.poster == user}, 
                      :create_conditions => lambda {|user, event| event.has_participant?(user)},
                      :view_conditions => lambda { true } # this means anyone can view

	acts_as_resource_feeds

	searcher_column :title

  def participants_count
    confirmed_count + maybe_count
  end

  def has_participant? user
    !participations.find(:first, :conditions => {:status => [Participation::Confirmed, Participation::Maybe], :participant_id => user.id}).blank?
  end

  def has_character? character
    !participations.find(:first, :conditions => {:status => [Participation::Confirmed, Participation::Maybe], :character_id => character.id}).blank?
  end

  def has_only_one_character_for? user
    participations.find(:all, :conditions => {:status => [Participation::Confirmed, Participation::Maybe], :participant_id => user.id}).count == 1
  end

  def participations_for user
    participations.find(:all, :conditions => {:participant_id => user.id})
  end

  def characters_for user
    all_characters.find(:all, :conditions => {:user_id => user.id})  
  end

  def is_guild_event?
    !guild_id.nil?
  end

  def was_guild_event?
    !guild_id_was.nil?
  end

  def is_requestable_by? user
    return -3 if expired 
    return -1 if user.characters.find(:first, :conditions => {:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id}).blank?

    if is_guild_event?
      return 1 if guild.has_member?(user)
      return -2
    else
      return 1 if privilege == 1 || (privilege == 2 and poster.has_friend? user)
      return 0
    end
  end

  def invitations= invitation_attrs
    return if invitation_attrs.blank?
    invitation_attrs.each do |attrs|
      invitations.build(:participant_id => attrs[:user_id], :character_id => attrs[:character_id])
    end
  end

  # poster_id, game_server_id, game_area_id, game_id 不能改
  # guild_id 不能改，如果存在的话

  def validate
    # check title
    if title.blank?
      errors.add_to_base("标题不能为空")
      return
    elsif title.length > 100
      errors.add_to_base("标题太长，最长100个字符")
      return
    end

    # check description
    if description.blank? 
      errors.add_to_base("描述不能为空")
      return
    elsif description.length > 10000
      errors.add_to_base("描述最长10000个字符")
      return
    end

    # check start time
    if start_time.blank?
      errors.add_to_base("开始时间不能为空")
      return
    elsif start_time <= Time.now 
      errors.add_to_base("开始时间不能比现在早")
      return
    end

    # check end time
    if end_time.blank?
      errors.add_to_base("结束时间不能为空")
      return
    elsif start_time and end_time <= start_time
      errors.add_to_base("结束时间不能比开始时间早")
      return
    end

  end

  def validate_on_create
    # poster_id = current_user.id, 不能改变

    if is_guild_event?
      if Guild.find(:first, :conditions => {:id => guild_id}).blank?
        errors.add_to_base("工会不存在")
        return
      end
      # game_id, game_area_id和game_server_id都是被自动赋值，不需要检查
    else
      if character_id.blank?
        errors.add_to_base("没有游戏角色")
        return
      elsif GameCharacter.find(:first, :conditions => {:user_id => poster_id, :id => character_id}).blank? 
        errors.add_to_base("游戏角色不存在")
        return
      end
    end
  end

  attr_readonly :poster_id, :character_id, :game_id, :game_area_id, :game_server_id, :guild_id

  attr_protected :expired

=begin
  def validate_on_update
    if poster_id_changed?
      errors.add_to_base("不能修改poster_id")
    elsif character_id_changed?
      errors.add_to_base("不能修改character_id")
    elsif game_id_changed?
      errors.add_to_base("不能修改game_id")
    elsif game_area_id_changed?
      errors.add_to_base("不能修改game_area_id")
    elsif game_server_id_changed?
      errors.add_to_base("不能修改game_server_id")
    elsif was_guild_event? and guild_id_changed?
      errors.add_to_base("不能修改guild_id")
    end
  end
=end

end
