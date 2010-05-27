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

      include InstanceMethods

      extend SingletonMethods

    end

  end 

  module SingletonMethods

    def verify_all opts
      self.update_all("verified = 1", opts)
    end

    def unverify_all opts
      self.update_all("verified = 2", opts)
    end

    def nonblocked_cond
      {:verified => [0,1]}
    end

  end

  module InstanceMethods

    def rejected?
      self.verified == 2
    end

    def accepted?
      self.verified == 1
    end

    def unverified?
      self.verified == 0
    end

    def needs_no_verify
      self.verified = 1
    end

    def needs_verify
      self.verified = 0
    end

    def recently_recovered?
      @verify_action == :recently_recovered
    end

    def recently_accepted?
      @verify_action == :recently_accepted
    end

    def recently_rejected?
      @verify_action == :recently_rejected
    end

    # 在before_create或者before_update里进行自动检查
    # 如果不包含敏感词就通过
    # 如果包括就需要检查
    def auto_verify
      if self.new_record?
        self.verified = self.sensitive? ? 0 : 1
      else
        if self.sensitive? and self.sensitive_columns_changed?
          self.verified = 0
        end
      end
    end

    def verify
      if self.verified != 1
        if self.verified == 2
          @verify_action = :recently_recovered
        else
          @verify_action = :recently_accepted
        end
        self.verified = 1
        save
      end  
    end

    def unverify
      if self.verified == 0 or self.verified == 1
        self.verified = 2
        @verify_action = :recently_rejected
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
