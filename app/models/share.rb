class Share < ActiveRecord::Base

  belongs_to :shareable, :polymorphic => true

  has_many :sharings, :order => 'created_at ASC', :dependent => :destroy

  has_many :sharers, :source => :poster , :through => :sharings

  has_one :first_sharer, :source => :poster, :through => :sharings, :order => "sharings.created_at DESC"

  named_scope :hot, lambda { |type|
    if type == 'all'
      { :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => 'digs_count DESC, created_at DESC' }
    else 
      { :conditions => ["created_at > ? AND shareable_type = ?", 2.weeks.ago.to_s(:db), type], :order => 'digs_count DESC' }
    end
  }

  named_scope :recent, lambda { |type|
    if type == 'all'
      { :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => 'created_at DESC' }
    else 
      { :conditions => ["created_at > ? AND shareable_type = ?", 2.weeks.ago.to_s(:db), type], :order => 'created_at DESC' }
    end
  }

  acts_as_diggable

  cattr_accessor :registered_resources

  self.registered_resources = {}

  def self.register resource, path_reg
    if path_reg.is_a? Array
      registered_resources["#{resource}"] = path_reg
    else
      registered_resources["#{resource}"] = [path_reg]
    end
  end

  def self.get_type_and_id path
    self.registered_resources.each do |resource, path_regs|
      path_regs.each do |reg|
        if path =~ reg
          return [resource, $1]
        end
      end
    end
    [nil, nil]
  end

end
