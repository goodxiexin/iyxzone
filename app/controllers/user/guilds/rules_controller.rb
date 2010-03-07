class User::Guilds::RulesController < UserBaseController

  def index
    case params[:type].to_i
    when 0
      render :partial => 'edit_attendance_rules'
    when 1
      render :partial => 'edit_basic_rules'
    end   
  end

  def create
    rule_params = (params[:rule] || {}).merge({:rule_type => 2, :guild_id => @guild.id})
    @rule = GuildRule.new(rule_params)
    if @rule.save
      render :json => @rule
    else
      render :json => {:errors => @rule.errors}
    end
  end

  # create new rules, or update existing rules 
  def create_or_update
    if @guild.update_attributes(params[:guild])
      @guild.reload
      if params[:type].to_i == 0
        render :partial => 'attendance_rules', :locals => {:guild => @guild}
      elsif params[:type].to_i == 1
        render :partial => 'basic_rules', :locals => {:guild => @guild}
      end
    else
      flash[:error] = "发生错误"
      redirect_to edit_guild_rules(@guild)
    end
  end

protected

  def setup
    if ["index", "create", "create_or_update"].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
    end
  end

end
