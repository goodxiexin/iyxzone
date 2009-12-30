# ActsAsTaggable
module Taggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_taggable

      has_many :taggings, :as => 'taggable', :dependent => :destroy

			has_many :tags, :through => :taggings, :uniq => true

			after_save :save_tags

      include Taggable::InstanceMethods

      extend Taggable::SingletonMethods

			alias_method_chain :reload, :tag_list

    end   

  end

  module SingletonMethods

		def find_tagged_with tags, options={}
			tags = tags.split(%r{,\s*}) if tags.is_a? String
			num = tags.count / 2 + 1
			puts num
			conditions = []
			conditions << sanitize_sql(options.delete(:conditions)) if options[:conditions]
			conditions << <<-END
				#{table_name}.id IN 
				(SELECT #{Tagging.table_name}.taggable_id FROM #{Tagging.table_name} 
				INNER JOIN #{Tag.table_name} ON #{Tagging.table_name}.tag_id = #{Tag.table_name}.id 
				WHERE #{Tagging.table_name}.taggable_type = '#{self.to_s}' AND #{tags_condition tags}
				GROUP BY #{Tagging.table_name}.taggable_id
				HAVING COUNT(*) >= #{num})
			END
			#Game.all.find_all {|g| !(g.tags.map(&:name) & tags).blank? }
			find(:all, :conditions => conditions.join(" AND "), :order => options[:order])
		end

		def tags_condition tags 
			condition = tags.map { |t| sanitize_sql(["#{Tag.table_name}.name LIKE ?", t]) }.join(" OR ")
      "(" + condition + ")"
    end

	end

  module InstanceMethods

		def tag_list
			return @tag_list if @tag_list
			@tag_list = TagList.new(*tags.map(&:name))				
		end

		# the following 2 methods are only used when poster of tagging is ignored
		def tag_list=(value)
			@tag_list = (value.is_a? Array) ? TagList.from(value.join(',')) : TagList.from(value)
		end

		def save_tags
			return unless @tag_list
			new_tag_names = @tag_list - tags.map(&:name)
			new_tag_names.each do |tag_name|
				tag = Tag.find_or_create(:name => tag_name, :taggable_type => self.class.to_s)
				tag.taggings.create(:taggable_type => self.class.to_s, :taggable_id => id)
			end
		end

		def reload_with_tag_list(*args)
			@tag_list = nil
			reload_without_tag_list(*args)
		end

		def tagged_by? user
			taggings.find_by_poster_id user.id
		end

  end

end

ActiveRecord::Base.send(:include, Taggable)

