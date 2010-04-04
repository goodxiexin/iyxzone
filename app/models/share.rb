class Share < ActiveRecord::Base

  belongs_to :shareable, :polymorphic => true

  has_many :sharings

  named_scope :hot, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"
  
  named_scope :recent, :conditions => ["created_at> ?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"

  acts_as_diggable 

end
