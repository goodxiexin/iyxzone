class Tagging < ActiveRecord::Base

	belongs_to :taggable, :polymorphic => true

	belongs_to :tag, :counter_cache => true

	belongs_to :poster, :class_name => 'User'

end
