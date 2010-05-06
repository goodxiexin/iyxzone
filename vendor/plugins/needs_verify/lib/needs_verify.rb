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
