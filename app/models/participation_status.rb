class ParticipationStatus

  attr_accessor :participation, :participant, :event

  def initialize participation
    @participation = participation
    @participant = @participation.participant
    @event = @participation.event
  end

  def before_create
  end

  def after_create
  end

  def before_update
  end

  def after_update
  end

  def before_destroy
  end

  def after_destroy
  end

end
