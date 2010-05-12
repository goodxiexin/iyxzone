# NeedsVerify
module NeedsVerify

  SENSITIVE_WORDS = []

  def self.included base
    base.extend(ClassMethods)
  
    # read sensitive words
    File.open('config/sensitive_words.yml') do |f|
      while word = f.gets
        SENSITIVE_WORDS << word.gsub(/\n/,'')
      end
    end
  end

  module ClassMethods
  
    def needs_verification opts={}

      # 举报
      has_many :reports, :as => 'reportable'

      named_scope :nonblocked, :conditions => {:verified => [0,1]}, :order => "created_at DESC"

      named_scope :unverified, :conditions => {:verified => 0}, :order => "created_at DESC"

      named_scope :accepted, :conditions => {:verified => 1}, :order => "created_at DESC"

      named_scope :rejected, :conditions => {:verified => 2}, :order => "created_at DESC"

      attr_protected :verified    

      cattr_accessor :verify_opts
    
      self.verify_opts = opts

      attr_accessor :recently_verified, :recently_verified_from_unverified, :recently_unverified

      include InstanceMethods

      extend SingletonMethods

    end

  end 

  module SingletonMethods

  end

  module InstanceMethods

    def needs_verify
      self.verified = 0
      self.save
    end

    def verify
      if self.verified != 1
        if self.verified == 2
          self.recently_verified_from_unverified = true
        else
          self.recently_verified = true
        end
        self.verified = 1
        save
      end  
    end

    def unverify
      if self.verified == 0 or self.verified == 1
        self.verified = 2
        self.recently_unverified = true
        save
      end
    end

    def sensitive?
      self.class.verify_opts[:sensitive_columns].each do |column|
        con = eval("self.#{column}")
        if !con.blank?
          SENSITIVE_WORDS.each do |word|
            return true if con.include? word
          end
        end
      end
      return false    
    end

    def sensitive_columns_changed?
      changed = false
      self.class.verify_opts[:sensitive_columns].each do |column|
        changed ||= eval("self.#{column}_changed?")
      end
      changed
    end

  end

end

ActiveRecord::Base.send(:include, NeedsVerify)
