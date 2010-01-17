class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, status, comment| status.poster == user || comment.poster == user },
                      :create_conditions => lambda {|user, status| status.poster == user || status.poster.has_friend?(user)}

  acts_as_emotion_text :columns => [:content]

	acts_as_resource_feeds

  def validate
    errors.add_to_base('没有作者') if poster_id.blank?

    # check content
    if content.blank?
      errors.add_to_base('内容为空')
    elsif content.length > 255
      errors.add_to_base('内容太长')
    end
  end  

end
