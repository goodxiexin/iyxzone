class User::Events::SummaryController < UserBaseController

  layout 'app'

  def show
    eval("setup_step_#{@step}")
  end

  def save
    eval("save_step_#{@step}")
    render :nothing => true
  end

  def next
    eval("save_step_#{@step}")
    render :update do |page|
      page.redirect_to :action => 'show', :event_id => @event.id, :step => @step + 1
    end
  end

  def prev
    eval("save_step_#{@step}")
    render :update do |page|
      page.redirect_to :action => 'show', :event_id => @event.id, :step => @step - 1
    end
  end

  def new_attendant
    @attendances = {}
    params[:ids].each do |id|
      @attendances["#{id}"] = {:late => 0, :complete => 100}
    end
    render :partial => 'attendance_info', :locals => {:attendances => @attendances}
  end

protected

  def setup
    @event = Event.find(params[:event_id])
    @guild = @event.guild
    setup_session_if_not_exist
    @summary = session[:event_summary]["#{@event.id}"]
    @step = params[:step].to_i
  rescue
    not_found
  end

  def clear_session
    session[:event_summary] = nil
  end

  def setup_session_if_not_exist
    if session[:event_summary].blank?
      session[:event_summary] = {}
    end
    if session[:event_summary]["#{@event.id}"].nil?
      session[:event_summary]["#{@event.id}"] = {}
    end
  end

  def setup_step_1
    if @summary[:attendances].nil?
      @summary[:attendances] = {}
      @event.confirmed_participations.each do |p|
        @summary[:attendances]["#{p.character_id}"] = {:late => 0, :complete => 100}
      end
    end
    @attendances = @summary[:attendances]
    @characters = @event.characters
    @ids = @attendances.keys
    @lates = @attendances.values.map {|v| v[:late]}
    @completes = @attendances.values.map {|v| v[:complete]}
  end

  def save_step_1
    @attendances = {}
    params[:characters].each do |id, info|
      @attendances["#{id}"] = {:late => info[:late].to_i, :complete => info[:complete].to_i}
    end
    @summary[:attendances] = @attendances
  end

  def setup_step_2
    if @summary[:bosses].nil?
      @summary[:bosses] = {}
    end
    @boss_infos = @summary[:bosses]
    @ids = @boss_infos.keys
    @counts = @boss_infos.values
    @bosses = Boss.find(@ids)
    @rewards = @bosses.map(&:reward)
    @names = @bosses.map(&:name)
  end

  def save_step_2
    @boss_infos = {}
    params[:bosses].each do |id, v|
      @boss_infos["#{id}"] = v[:count]
    end unless params[:bosses].blank?
    @summary[:bosses] = @boss_infos
  end

  def setup_step_3
    if @summary[:gears].nil?
      @summary[:gears] = {}    
    end
    @gear_infos = @summary[:gears]
    @character_ids = []
    @gear_ids = []
    @gear_infos.keys.each do |key|
      @character_ids << key.split('_').last
      @gear_ids << key.split('_').first
    end
    @characters = GameCharacter.find(@summary[:attendances].keys)
    @counts = @gear_infos.values
    @gears = Gear.find(@gear_ids)
    @costs = @gears.map(&:cost)
    @names = @gears.map(&:name)
  end

  def save_step_3
    @gear_infos = {}
    params[:info].each do |id, v|
      @gear_infos["#{id}"] = v[:count]
    end unless params[:info].blank?
    @summary[:gears] = @gear_infos
  end

  def setup_step_4
    if @summary[:rules].nil?
      @summary[:rules] = {}
    end
    @rule_infos = @summary[:rules]
    @rule_ids = []
    @character_ids = []
    @rule_infos.keys.each do |key|
      @rule_ids << key.split('_').first
      @character_ids << key.split('_').last
    end
    @attendants = GameCharacter.find(@summary[:attendances].keys)
    @counts = @rule_infos.values
    @rules = @guild.rules.find(@rule_ids)
    @characters = GameCharacter.find(@character_ids)
    @reasons = @rules.map(&:reason)
    @outcomes = @rules.map(&:outcome)
  end

  def save_step_4
    @rule_infos = {}
    params[:info].each do |id, v|
      @rule_infos["#{id}"] = v[:count]
    end unless params[:info].blank?
    @summary[:rules] = @rule_infos
  end

end
