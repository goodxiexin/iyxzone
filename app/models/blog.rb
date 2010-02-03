class Blog < ActiveRecord::Base

  belongs_to :game

	belongs_to :poster, :class_name => 'User'

  named_scope :hot, :conditions => ["draft = 0 AND created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

  named_scope :recent, :conditions => ["draft = 0 AND created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"

  acts_as_friend_taggable :delete_conditions => lambda {|user, blog| blog.poster == user},
                          :create_conditions => lambda {|user, blog| blog.poster == user}

  acts_as_viewable :create_conditions => lambda {|user, blog| blog.poster != user}

	acts_as_diggable :create_conditions => lambda {|user, blog| blog.privilege != 4 or blog.poster == user}

	acts_as_privileged_resources

  acts_as_resource_feeds

  acts_as_shareable

  acts_as_list :order => 'created_at', :scope => 'poster_id', :conditions => {:draft => false}

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, blog, comment| user == blog.poster || user == comment.poster}, 
                      :create_conditions => lambda {|user, blog| (user == blog.poster) || (blog.privilege == 1) || (blog.privilege == 2 and (blog.poster.has_friend? user or blog.poster.has_same_game_with? user)) || (blog.privilege == 3 and blog.poster.has_friend? user) || false}

  def validate
    # check title
    if title.blank?
      errors.add_to_base('标题不能为空')
    elsif title.length > 100
      errors.add_to_base('标题最长100个字符')
    end

    # check poster
    errors.add_to_base('没有作者') if poster_id.blank?
   
    # check content
    if content.blank?   
      errors.add_to_base('内容不能为空')
    elsif content.length >= 10000
      errors.add_to_base('内容最长10000个字符')
    end

    # check game
    if game_id.blank?
      errors.add_to_base('请选择游戏类别')
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base('游戏不存在')
    end

  end

end
