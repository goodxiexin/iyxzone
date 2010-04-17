class Viewing < ActiveRecord::Base

  belongs_to :viewer, :class_name => 'User', :foreign_key => 'user_id'

  belongs_to :viewable, :polymorphic => true

  # 不需要检验，系统创建

end
