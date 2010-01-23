#
# FriendTag就是blog, video的标签（谁和这个资源有关）
#

class FriendTag < ActiveRecord::Base

  belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :taggable, :polymorphic => true

	belongs_to :blog, :foreign_key => 'taggable_id'

	belongs_to :video, :foreign_key => 'taggable_id'

	has_many :notices, :as => 'producer', :dependent => :destroy 

  def is_deleteable_by? user
    taggable.is_tag_deleteable_by? user, self
  end

  def validate_on_create
    if poster_id.blank?
      errors.add_to_base("没有发布者")
      return
    end

    if tagged_user_id.blank?
      errors.add_to_base("没有被标记的人")
      return
    elsif !poster.has_friend?(tagged_user_id) and tagged_user_id != poster_id
      errors.add_to_base("被标记的不是好友或本人")
      return
    end

    if taggable_id.blank? or taggable_type.blank?
      errors.add_to_base("没有被标记的资源")
      return
    else 
      taggable = taggable_type.constantize.find(:first, :conditions => {:id => taggable_id})
      if taggable.blank?
        errors.add_to_base("被标记的资源不存在")
        return
      elsif taggable.tags.find_by_tagged_user_id(tagged_user_id)
        errors.add_to_base('已经标记过了')
        return
      elsif !taggable.is_taggable_by? poster
        errors.add_to_base('没有权限标记')
        return
      end
    end
  end

end


