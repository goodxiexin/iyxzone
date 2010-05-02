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

      named_scope :unverified, :conditions => {:verified => 0}, :order => "created_at DESC"

      named_scope :accepted, :conditions => {:verified => 1}, :order => "created_at DESC"

      named_scope :rejected, :conditions => {:verified => 2}, :order => "created_at DESC"

      attr_protected :verified    

      cattr_accessor :verify_opts
    
      self.verify_opts = opts

      if !opts[:sensitive_columns].blank?
        before_create :verify_sensitive_columns_on_create
        before_update :verify_sensitive_columns_on_update
      end

      include InstanceMethods

      extend SingletonMethods

    end

  end 

  module SingletonMethods

  end

  module InstanceMethods

    def verify
      self.verified = 1
      save  
    end

    def unverify
      self.verified = 2
      save
    end

    def masked?
      self.verified == 2
    end

    def verify_sensitive_columns_on_create
      verify_sensitive_columns
    end

    def verify_sensitive_columns_on_update
      verify_sensitive_columns if sensitive_columns_changed?
    end

  protected

    def sensitive_columns_changed?
      changed = false
      self.class.verify_opts[:sensitive_columns].each do |column|
        changed ||= eval("self.#{column}_changed?")
      end
      changed
    end

    # 如果不包含敏感词，就自动变成审核通过，如果包含敏感词，就变成待审核
    def verify_sensitive_columns
      self.class.verify_opts[:sensitive_columns].each do |column|
        con = eval("self.#{column}")
        SENSITIVE_WORDS.each do |word|
          if con.include? word
            self.verified = 0
            return
          end
        end  
      end
      self.verified = 1
    end
  
  end

end

ActiveRecord::Base.send(:include, NeedsVerify)
