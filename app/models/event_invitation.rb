class EventInvitationStatus < ParticipationStatus
  
  def after_create
    @participant.raw_increment :event_invitations_count
    @event.raw_increment :invitations_count  
    EventMailer.deliver_invitation @event, @participation if @participant.mail_setting.invite_me_to_event?
  end

  def after_update
    
  end

end
