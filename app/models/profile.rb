class Profile < ActiveRecord::Base

  belongs_to :user

	belongs_to :region

	belongs_to :city

	belongs_to :district

  has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

  acts_as_viewable

	acts_as_resource_feeds

  acts_as_taggable :delete_conditions => lambda {|profile, user| profile.user == user},
                   :create_conditions => lambda {|tagging, profile, user| (tagging.nil? || tagging.created_at < 1.week.ago) and (profile.user.has_friend? user)}

  acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, profile, comment| profile.user == user}, 
                      :create_conditions => lambda {|user, profile| profile.user == user || profile.user.has_friend?(user) || profile.user.privacy_setting.leave_wall_message == 1}  

  attr_protected :user_id # user_id can't be assigned massively

  def viewable_by viewer
    privilege = user.privacy_setting.personal
    user == viewer || privilege == 1 || user.has_friend?(viewer) || (privilege == 2 and user.has_same_game_with?(current_user))
  end

  def basic_info_changed?
    login_changed? || gender_changed? || region_id_changed? || city_id_changed? || district_id_changed? || birthday_changed?
  end

  def contact_info_changed?
    qq_changed? || phone_changed? || website_changed?
  end

  def validate_on_update
    # check login
    if login.blank?
      errors.add_to_base("昵称不能为空")
      return
    elsif login.length < 4 or login.length > 16
      errors.add_to_base("昵称长度不对")
      return
    elsif /^\d/.match(login)
      errors.add_to_base("昵称不能以数字开头")
      return
      # TODO: how to validate chinese characters
    end

    # check gender
    if gender.blank?
      errors.add_to_base("性别为空")
      return
    elsif gender != 'male' and gender != 'female'
      errors.add_to_base("未知的性别")
      return
    end

    # check birthday
    if birthday
      if birthday > Time.now
        errors.add_to_base("生日比今天还晚")
        return
      elsif birthday < 40.years.ago
        errors.add_to_base("你这么老了阿")
        return
      end
    end
    
    # check region, city, district
    if region_id.blank?
      if !city_id.blank? or !district_id.blank?
        errors.add_to_base("没有省份")
        return
      end
    else
      if city_id.blank?
        if !district_id.blank?
          errors.add_to_base("没有城市")
          return
        end
      else
        if City.find(:first, :conditions => {:region_id => region_id, :id => city_id}).blank? 
          errors.add_to_base("城市不存在")
          return
        elsif !district_id.blank? and District.find(:first, :conditions => {:city_id => city_id, :id => district_id}).blank?
          errors.add_to_base("地区不存在")
          return
        end
      end
    end
    
    # check qq
    if qq
      if !/\d+/.match(qq)   
        errors.add_to_base("qq只能是数字") 
        return
      elsif qq.length < 4 or qq.length > 15
        errors.add_to_base("qq号码长度不对")
        return
      end
    end

    # check phone
    if phone
      if !/\d+/.match(phone)
        errors.add_to_base("电话只能是数字")
        return
      elsif phone.length < 8 or phone.length > 15
        errors.add_to_base("电话长度不对")
        return
      end
    end
  
    # check website
    if website 
      # TODO: 这个regular expression貌似不够强大，不能把adsfadsf视为非法的url
      unless website =~ /^((https?:\/\/)?)(([a-zA-Z0-9_-])+(\.)?)*(:\d+)?(\/((\.)?(\?)?=?&?[a-zA-Z0-9_-](\?)?)*)*$/
        errors.add_to_base("非法的url")
        return
      end 
    end

  end

end

