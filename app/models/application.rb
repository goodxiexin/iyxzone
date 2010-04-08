class Application < ActiveRecord::Base

  acts_as_commentable :order => 'created_at DESC', :recipient_required => false

  def validate
    if name.blank?
      errors.add_to_base("不能没有名字")
      return false
    end
  end

end
