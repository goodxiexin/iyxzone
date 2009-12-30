#
# 说明
# FriendTag就是blog, video的标签（谁和这个资源有关）
#

class FriendTag < ActiveRecord::Base

  belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :taggable, :polymorphic => true

	belongs_to :blog, :foreign_key => 'taggable_id'

	belongs_to :video, :foreign_key => 'taggable_id'

	has_many :notices, :as => 'producer', :dependent => :destroy 

  class TagNoneFriendError < StandardError; end

end


