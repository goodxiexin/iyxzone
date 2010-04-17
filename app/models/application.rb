class Application < ActiveRecord::Base

  acts_as_commentable :order => 'created_at DESC', :recipient_required => false

  # 不检测，因为这个是系统生成的

end
