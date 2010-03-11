namespace :tags do

  desc "删除没人使用的tag"
	task :delete_unused_tags => :environment do 
		tags = Tag.find(:all, :conditions => {:taggings_count => 0})
		Tag.destroy(tags.map(&:id))
	end

end
