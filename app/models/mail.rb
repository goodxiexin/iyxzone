class Mail < ActiveRecord::Base

  attr_accessor :recipients

  belongs_to :sender, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

	belongs_to :parent, :class_name => 'Mail'
 
  has_many :children, :class_name => 'Mail', :foreign_key => 'parent_id', :order => 'created_at ASC'

  named_scope :unread, :conditions => {:read_by_recipient => 0}

  attr_readonly :sender_id, :recipient_id

  attr_protected :parent_id

  validates_presence_of :sender_id

  validates_presence_of :recipient_id

  validates_presence_of :parent_id

  validates_presence_of :content

  validates_size_of :content, :within => 1..1000

  def mark_as_deleted(user_id)
    if recipient?(user_id)
      update_attribute(:delete_by_recipient, true)
    elsif sender?(user_id)
      update_attribute(:delete_by_sender, true)
    end
  end

private

  def recipient?(user_id)
    (recipient_id == user_id)? true : false
  end

  def sender?(user_id)
    (sender_id == user_id)? true : false
  end

end
