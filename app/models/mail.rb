class Mail < ActiveRecord::Base

  attr_accessor :recipients

  belongs_to :sender, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

	belongs_to :parent, :class_name => 'Mail'
 
  has_many :children, :class_name => 'Mail', :foreign_key => 'parent_id', :order => 'created_at ASC'

	acts_as_emotion_text :columns => [:content]

  named_scope :unread, :conditions => {:read_by_recipient => 0}

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

  def delete_by_both?
    (delete_by_recipient and delete_by_sender)? true : false
  end

end
