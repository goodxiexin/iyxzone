class Share < ActiveRecord::Base

  belongs_to :shareable, :polymorphic => true

  has_many :sharings, :order => 'created_at ASC', :dependent => :destroy

  named_scope :hot, lambda { |type|
    if type == 'all'
      { :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => 'digs_count DESC' }
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

end
