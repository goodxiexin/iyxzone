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
      before_create :make_invite_fan_code
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

      validates_uniqueness_of :email, :message => "邮件已经被注册了"

      validates_presence_of :password, :message => "不能为空", :if => :require_password?

      validates_size_of :password, :within => 6..20, :too_long => "最长20个字符", :too_short => "最短6个字符", :if => :require_password?

      validates_presence_of :password_confirmation, :message => "没有确认密码", :if => :require_password?

      validates_confirmation_of :password, :message => "2次密码不一致", :if => :require_password?

    end

    recipient.extend(UserAuthentication::ClassMethods)

  end

  module ClassMethods
  
    def authenticate(email, password)
      u = find :first, :conditions => ['email = ?', email]
      u && u.authenticated?(password) ? u : nil
    end

    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

  end


  module InstanceMethods

    def activate
      @action = :activated
      self.activated_at = Time.now.utc
      self.activation_code = nil
      save(false)
    end

    def active?
      activation_code.nil?
    end

    def authenticated?(password)
      crypted_password == encrypt(password)
    end
    
    def forgot_password
      @action = :forgotten_password
      self.make_password_reset_code
      self.save
    end

    def reset_password password, password_confirmation
      self.password = password
      self.password_confirmation = password_confirmation
      @action = :changing_password
      if self.save
        #@changing_password = false
        @action = :reset_password
        self.password_reset_code = nil
        self.save
      else
        #@changing_password = false
        false
      end
    end

    def require_password?
      crypted_password.blank? || recently_changing_password?
    end

    def has_role?(name)
      self.roles.find_by_name(name) ? true : false
    end

    def recently_changing_password?
      @action == :changing_password
    end

    def recently_activated?
      @action == :activated
    end

    def recently_forgot_password?
      @action == :forgotten_password
    end

    def recently_reset_password?
      @action == :reset_password
    end

    # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password, salt)
    end

    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

  protected

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

    def make_invite_fan_code
      self.invite_fan_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ) if is_idol
    end

    def make_qq_invite_code
      self.qq_invite_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def make_msn_invite_code
      self.msn_invite_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

  end

end
