class Album < ActiveRecord::Base

	belongs_to :poster, :class_name => 'User'

  belongs_to :game

	acts_as_commentable :order => 'created_at ASC'

  acts_as_resource_feeds

  validate do |album|
    album.errors.add_to_base('标题不能为空') if album.title.blank?
    album.errors.add_to_base('请选择游戏类别') if album.game_id.blank?
    album.errors.add_to_base('标题最长100个字符') if album.title and album.title.length >= 100
    album.errors.add_to_base('描述最长500个字符') if album.description and album.description.length >= 500
  end

	def recent_photos limit
		photos.find(:all, :limit => limit)
	end

end
