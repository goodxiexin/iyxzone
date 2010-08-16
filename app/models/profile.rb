class Profile < ActiveRecord::Base

  belongs_to :user

  belongs_to :skin

	belongs_to :region

	belongs_to :city

	belongs_to :district

  acts_as_viewable :create_conditions => lambda {|profile, user| profile.user != user}

  acts_as_feed_recipient :delete_conditions => lambda {|user, profile| profile.user == user}

	acts_as_resource_feeds :recipients => lambda {|profile| ([profile] + profile.user.friends + (profile.user.is_idol ? profile.user.fans : [])).uniq}

  acts_as_taggable :delete_conditions => lambda {|profile, user| profile.user == user}, 
                   :create_conditions => lambda {|tagging, profile, user| (tagging.nil? || tagging.created_at < 10.days.ago) and user != profile.user and user.relationship_with(profile.user) == 'friend'}

  acts_as_commentable :order => 'created_at DESC', 
                      :delete_conditions => lambda {|user, profile, comment| profile.user == user}, 
                      :view_conditions => lambda {|user, profile| profile.user.is_idol or profile.user.privacy_setting.wall?(user.relationship_with profile.user)}, 
                      :create_conditions => lambda {|user, profile| profile.user.is_idol or profile.user.privacy_setting.leave_wall_message?(user.relationship_with profile.user)}

  validate :skin_is_accessible

  def accessible_skins
    Skin.for('Profile').select {|skin| skin.accessible_for?(self)}
  end

  def available_for? relationship
    user.is_idol or user.privacy_setting.profile?(relationship)
  end

  def basic_info_viewable? relationship
    user.is_idol or user.privacy_setting.basic_info?(relationship)
  end

  def email_viewable? relationship
    user.is_idol or user.privacy_setting.email?(relationship)
  end

  def phone_viewable? relationship
    user.is_idol or user.privacy_setting.phone?(relationship)
  end

  def qq_viewable? relationship
    user.is_idol or user.privacy_setting.qq?(relationship)
  end

  def website_viewable? relationship
    user.is_idol or user.privacy_setting.website?(relationship)
  end

  def characters_viewable? relationship
    user.is_idol or user.privacy_setting.character_info?(relationship)
  end

  def basic_info_changed?
    login_changed? || gender_changed? || region_id_changed? || city_id_changed? || district_id_changed? || birthday_changed?
  end

  def contact_info_changed?
    qq_changed? || phone_changed? || website_changed?
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

  validates_size_of :login, :within => 2..30

  validates_uniqueness_of :login, :case_sensitive => false

  validates_inclusion_of :gender, :in => ['male', 'female']

  validate :birthday_is_valid
    
  validate :region_is_valid

  validate :city_is_valid
  
  validate :district_is_valid

  validates_size_of :qq, :within => 4..15, :allow_blank => true

  validates_format_of :qq, :with => /\d+/, :allow_blank => true

  validates_size_of :phone, :within => 7..15, :allow_blank => true

  validates_format_of :phone, :with => /\d+(-(\d+))*/, :allow_blank => true

  validates_format_of :website, :with => /^((https?:\/\/)?)([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-]+))+(:([\d])+)*([\/a-zA-Z0-9\.\?=&_-])*$/, :allow_blank => true

protected

  def birthday_is_valid
    return if birthday.blank?
    if birthday >= Time.now.beginning_of_day
      errors.add(:birthday, "生日比今天还晚")
    elsif birthday < 40.years.ago
      errors.add(:birthday, "你这么老了阿")
    end
  end

  def region_is_valid
    return if region_id.blank?
    errors.add(:region_id, "不存在") unless Region.exists? region_id
  end

  def city_is_valid
    return if city_id.blank?
    errors.add(:city_id, "不存在") unless City.exists? :region_id => region_id, :id => city_id
  end

  def district_is_valid
    return if district_id.blank?
    errors.add(:district_id, "不存在") unless District.exists? :city_id => city_id, :id => district_id
  end

  def skin_is_accessible
    !skin.blank? and skin.accessible_for?(self)
  end

end

