require 'app/mailer/tag_mailer'

class TaggingObserver < ActiveRecord::Observer
  
  def after_create tagging
    # increment counter
    tagging.tag.raw_increment :taggings_count

    # send notification if it's profile tag
    if tagging.taggable_type == 'Profile'
      profile = tagging.taggable
      profile.user.notifications.create(
        :category => Notification::FriendTag,
        :data => "#{profile_link tagging.poster} 对你的印象是: #{tagging.tag.name}")
      TagMailer.deliver_profile_tag tagging if profile.user.mail_setting.tag_my_profile?
    end
  end

  def after_destroy tagging
    tagging.tag.raw_decrement :taggings_count
  end

end
