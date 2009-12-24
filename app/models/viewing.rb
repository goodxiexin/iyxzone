class Viewing < ActiveRecord::Base

  belongs_to :viewer, :class_name => 'User', :foreign_key => 'user_id'

  belongs_to :viewable, :polymorphic => true, :counter_cache => true

end
