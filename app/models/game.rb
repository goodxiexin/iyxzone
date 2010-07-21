class Game < ActiveRecord::Base

  has_many :role_users, :foreign_key => 'data'

  has_many :admins, :through => :role_users, :source => :user

  def has_admin? user
    !role_users.find_by_user_id(user).blank?
  end

  has_many :servers, :class_name => 'GameServer'
  
  has_many :areas, :class_name => 'GameArea'

  has_many :professions, :class_name => 'GameProfession'

  has_many :races, :class_name => 'GameRace'

	has_many :events, :order => 'confirmed_count DESC'

	has_many :guilds, :order => '(members_count + veterans_count + 1) DESC'

	has_many :albums, :class_name => 'Album', :order => "uploaded_at DESC", :conditions => "photos_count != 0"

	has_many :blogs, :order => 'created_at DESC'

	has_many :characters, :class_name => 'GameCharacter'

	has_many :users, :through => :characters, :conditions => "users.activated_at IS NOT NULL", :uniq => true

  has_many :news

  named_scope :sexy, :order => "(characters_count - last_week_characters_count) DESC"

	named_scope :hot, :conditions => "attentions_count != 0", :order => "(attentions_count - last_week_attentions_count) DESC" 

	named_scope :beta, :conditions => ["sale_date > ?", Time.now.to_s(:db)], :order => 'sale_date ASC'
  
  named_scope :recent, :conditions => ["created_at > ?", 1.week.ago.to_s(:db)], :order => "characters_count DESC, created_at DESC"

  acts_as_attentionable

	acts_as_taggable :delete_conditions => lambda {|game, user| user.is_admin? },
                   :create_conditions => lambda {|tagging, game, user| tagging.nil? || tagging.created_at < 10.days.ago }
  
	acts_as_rateable :create_conditions => lambda {|rating, game, user| (rating.nil? || rating.created_at < 10.days.ago) and user.has_game?(game) }

	acts_as_commentable :order => 'created_at DESC', :recipient_required => false,
                      :delete_conditions => lambda {|user, blog, comment| user.is_admin?}

  acts_as_pinyin :name => "pinyin" 

  acts_as_feed_recipient

	def new_game?
		sale_date.nil? or sale_date > Date.today
	end

  def relative_new?
		sale_date.nil? or sale_date > Date.today<<(12)
	end  

	def no_servers
		servers_count == 0
	end

	def no_areas
		areas_count == 0
	end

	def no_races
		races_count == 0
	end

	def no_professions
		professions_count == 0
	end

  validates_size_of :bulletin, :within => 1..50, :allow_blank => true

end
