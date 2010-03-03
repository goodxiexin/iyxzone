class SignupInvitation < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User'

  validates_presence_of :recipient_email, :message => "不能为空"

  validates_format_of :recipient_email, :with => /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/, :message => "不能为空", :allow_nil => true

end
