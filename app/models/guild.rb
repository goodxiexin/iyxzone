class Guild < ActiveRecord::Base
  
  belongs_to :game

  belongs_to :president, :class_name => 'User'

  has_one :forum

  has_many :memberships

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  has_many :guild_friendships

  has_many :friends, :through => :guild_friendships, :source => 'friend'

  has_many :invitations, :class_name => 'Membership', :conditions => {:status => 0}

  has_many :requests, :class_name => 'Membership', :conditions => {:status => [1,2]}

  named_scope :hot, :order => '(members_count + veterans_count + 1) DESC'

  named_scope :recent, :order => 'created_at DESC'

	with_options :through => :memberships, :source => 'user' do |guild|

		guild.has_many :all_members, :conditions => "memberships.status = 3 or memberships.status = 4 or memberships.status = 5"

		guild.has_many :requestors, :conditions => "memberships.status = 1 or memberships.status = 2"

		guild.has_many :invitees, :conditions => "memberships.status = 0"

		guild.has_many :members, :conditions => "memberships.status = 5"

		guild.has_many :veterans, :conditions => "memberships.status = 4"

		guild.has_many :veterans_and_members, :conditions => "memberships.status = 4 or memberships.status = 5"

		guild.has_many :president_and_veterans, :conditions => "memberships.status = 3 or memberships.status = 4"

	end

  acts_as_feed_recipient :delete_conditions => lambda {|user, guild| guild.president == user },
                         :categories => {
                            :blog => 'Blog',
                            :video => 'Video',
                            :poll => 'Poll',
                            :vote => 'Vote',
                            :event => 'Event',
                            :participation => 'Participation',
                            :personal_album => 'PersonalAlbum'
                          }

	acts_as_resource_feeds

	acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, guild, comment| guild.president == user}, 
                      :create_conditions => lambda {|user, guild| guild.has_member?(user)}

	searcher_column :name

  def events
    self.president_and_veterans(:include => :events).map { |member| member.events}.flatten.sort {|a,b| a.created_at <=> b.created_at}
  end

	def all_count
		veterans_count + members_count + 1
	end

  def has_member? user
    !memberships.find(:first, :conditions => {:user_id => user.id, :status => [3,4,5]}).blank? 
  end

  def validate
    # check name
    if name.blank?
      errors.add_to_base('名字不能为空')
    elsif name.length > 100
      errors.add_to_base('名字最长100个字符')
    end

    # check description
    if description.blank?
      errors.add_to_base('描述不能为空')
    elsif description.length > 10000
      errors.add_to_base('描述最长10000个字符')
    end

    # check game
    if game_id.blank?
      errors.add_to_base('游戏类别不能为空')
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base('游戏不存在')
    end
  end
  
end
