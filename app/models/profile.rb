class Profile < ActiveRecord::Base

  belongs_to :user

	belongs_to :skin

	belongs_to :region

	belongs_to :city

	belongs_to :district

  acts_as_viewable :create_conditions => lambda {|user, profile| profile.user != user}

  acts_as_shareable :default_title => lambda {|profile| "玩家#{profile.user.login}"}, :path_reg => /\/profiles\/([\d]+)/
  
  acts_as_feed_recipient :delete_conditions => lambda {|user, profile| profile.user == user},
                         :categories => {
														:status => 'Status',
                            :video => 'Video',
                            :poll => 'Poll',
                            :vote => 'Vote',
                            :event => 'Event',
                            :participation => 'Participation',
                            :guild => 'Guild',
                            :membership => 'Membership',
														:friendship => 'Friendship',
                            :sharing => 'Sharing'
													}

	acts_as_resource_feeds

  acts_as_taggable :delete_conditions => lambda {|profile, user| profile.user == user},
                   :create_conditions => lambda {|tagging, profile, user| (tagging.nil? || tagging.created_at < 10.days.ago) and (profile.user.has_friend? user)}

  acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, profile, comment| profile.user == user}, 
                      :create_conditions => lambda {|user, profile| profile.user == user || profile.user.has_friend?(user) || profile.user.privacy_setting.leave_wall_message == 1 || (profile.user.privacy_setting.leave_wall_message == 2 and profile.user.has_same_game_with?(user))},
                      :view_conditions => lambda {|user, profile| profile.user == user || profile.user.has_friend?(user) || profile.user.privacy_setting.wall == 1 || (profile.user.privacy_setting.wall == 2 and profile.user.has_same_game_with?(user))}  

  def available_for? viewer
    privilege = user.privacy_setting.personal
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def basic_info_changed?
    login_changed? || gender_changed? || region_id_changed? || city_id_changed? || district_id_changed? || birthday_changed?
  end

  def basic_info_viewable_by? viewer
    privilege = user.privacy_setting.basic_info
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def contact_info_changed?
    qq_changed? || phone_changed? || website_changed?
  end

  def email_viewable_by? viewer
    privilege = user.privacy_setting.email
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def qq_viewable_by? viewer
    privilege = user.privacy_setting.qq
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def phone_viewable_by? viewer
    privilege = user.privacy_setting.phone
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def website_viewable_by? viewer
    privilege = user.privacy_setting.website
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  def character_info_viewable_by? viewer
    privilege = user.privacy_setting.character_info
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(viewer))
  end

  after_save :save_characters

  def new_characters= character_attrs
    @new_characters_attrs = character_attrs
  end

  def existing_characters= character_attrs
    @existing_characters_attrs = character_attrs
  end  

  def del_characters= character_ids
    @del_characters_ids = character_ids
  end 

  def save_characters
    unless @new_characters_attrs.blank?
      @new_characters_attrs.each_value do |attrs|
        user.characters.create(attrs)
      end
    end
    @new_characters_attrs = nil
    unless @existing_characters_attrs.blank?
      @existing_characters_attrs.each do |id, attrs|
        user.characters.find(id).update_attributes(attrs)
      end
    end
    @existing_characters_attrs = nil
    # 我对这个很不满意，为了敷衍编辑档案那里，但是招不到更好的办法了   
    unless @del_characters_ids.blank?
      @del_characters_ids.each do |id|
        character = user.characters.find(id)
        character.destroy if !character.is_locked?
      end
    end
    @del_characters_ids = nil
  end

  before_save :set_completeness

  def set_completeness
    total = Profile.columns.count - 1 # except completeness column
    not_blank = 0
    Profile.columns.each do |c|
      if c.name != 'completeness' and !eval("self.#{c.name}").blank?
        not_blank = not_blank + 1
      end
    end
    self.completeness = (not_blank * 100) / total
  end
  
  attr_readonly :user_id

  validates_presence_of :login, :message => "不能为空"

  validates_size_of :login, :within => 2..100, :too_long => "最长100个字符", :too_short => "最短2个字符"

  validates_presence_of :gender, :message => "不能为空"

  validates_inclusion_of :gender, :in => ['male', 'female'], :message => "只能是male或者female"

  validate :birthday_is_valid
    
  validate :region_is_valid

  validate :city_is_valid
  
  validate :district_is_valid

  validates_size_of :qq, :within => 4..15, :too_short => "最短4位", :too_long => "最长15位", :if => "!qq.blank?"

  validates_format_of :qq, :with => /\d+/, :message => "只能是数字", :if => "!qq.blank?"

  validates_size_of :phone, :within => 7..15, :too_short => "最短7位", :too_long => "最长15位", :if => "!phone.blank?"

  validates_format_of :phone, :with => /\d+(-(\d+))*/, :message => "只能是数字或者-", :if => "!phone.blank?"

  validates_format_of :website, :with => /^((https?:\/\/)?)([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-]+))+(:([\d])+)*([\/a-zA-Z0-9\.\?=&_-])*$/, :message => "非法的url", :if => "!website.blank?"

protected

  def birthday_is_valid
    return if birthday.blank?
    if birthday > Time.now
      errors.add(:birthday, "生日比今天还晚")
      return
    elsif birthday < 40.years.ago
      errors.add(:birthday, "你这么老了阿")
      return
    end
  end

  def region_is_valid
    return if region_id.blank?
    errors.add(:region_id, "不存在") unless Region.exists? region_id
  end

  def city_is_valid
    return if region.blank? or city_id.blank?
    errors.add(:city_id, "不存在") unless City.exists? :region_id => region_id, :id => city_id
  end

  def district_is_valid
    return if city.blank? or district_id.blank?
    errors.add(:district_id, "不存在") unless District.exists? :city_id => city_id, :id => district_id
  end

end

