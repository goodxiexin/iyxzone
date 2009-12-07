class Tag < ActiveRecord::Base

	has_many :taggings, :dependent => :destroy

	named_scope :game_tags, :conditions => {:taggable_type => 'Game'}

	named_scope :profile_tags, :conditions => {:taggable_type => 'Profile'}

	def create_on_validate
		if self.name.nil?
			errors.add_to_base('名字不能为空')
		else
			tag = Tag.find_by_name_and_taggable_type(name, taggable_type)
			unless tag.nil?
				errors.add_to_base('名字已经有了')
			end
		end
	end

end
