class Dig < ActiveRecord::Base

  belongs_to :poster, :class_name => 'user'

  belongs_to :diggable, :polymorphic => true, :counter_cache => true

end
