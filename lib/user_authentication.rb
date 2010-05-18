#
# 其实就是把一群大便代码日到这里，让user减肥下
# 这一群代码是关于注册／激活／密码／校验的
#
module UserAuthentication

  def self.included(recipient)
    recipient.class_eval do
      include UserAuthentication::InstanceMethods

      attr_accessor :password, :password_confirmation
      attr_reader :enabled

      # callbacks
      before_save :encrypt_password
      before_create :make_activation_code
      before_create :make_remember_code
      before_create :make_invite_code
      before_create :make_qq_invite_code
      before_create :make_msn_invite_code
    
      named_scope :activated, :conditions => {:activation_code => nil}
      
      named_scope :pending, :conditions => "activation_code IS NOT NULL"

      attr_accessible :login, :password, :password_confirmation, :gender, :avatar_id

      validates_presence_of :login, :message => "不能为空"

      validates_size_of :login, :within => 2..100, :too_long => "最长100个字符", :too_short => "最短2个字符"

      validates_presence_of :gender, :message => "不能为空"

      validates_inclusion_of :gender, :in => ['male', 'female'], :message => "只能是male或者female"

      validates_presence_of :email, :message => "不能为空"

      validates_format_of :email, :with => /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/, :message => "邮件格式不对"

      validate_on_create :email_is_unique

    end

    recipient.extend(UserAuthentication::ClassMethods)

  end

  module ClassMethods
  
    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

  end


  module InstanceMethods

    # Activates the user in the database.
    def activate
      @activated = true
      self.activated_at = Time.now.utc
      self.activation_code = nil
      save(false)
    end

    def active?
      # the existence of an activation code means they have not activated yet
      activation_code.nil?
    end

    def authenticated?(password)
      crypted_password == encrypt(password)
    end
    
    def forgot_password
      @forgotten_password = true
      self.make_password_reset_code
    end

    def reset_password
      update_attribute(:password_reset_code, nil)
      @reset_password = true
    end

    def has_role?(name)
      self.roles.find_by_name(name) ? true : false
    end

    # Returns true if the user has just been activated.
    def recently_activated?
      @activated
    end

    def recently_forgot_password?
      @forgotten_password
    end

    def recently_reset_password?
      @reset_password
    end

    def invitation_token
      invitation.token if invitation
    end

    def invitation_token=(token)
      self.invitation = BetaInvitation.find_by_token(token)
    end

      # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password, salt)
    end

protected
  
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def make_remember_code
      self.remember_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )    
    end

    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def make_invite_code
      self.invite_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end   

    def make_qq_invite_code
      self.qq_invite_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def make_msn_invite_code
      self.msn_invite_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def email_is_unique
      return if email.blank?
      if !User.find_by_email(email.downcase).blank?
        errors.add(:email, "邮件已经被注册了")
      end
    end

  end

end
