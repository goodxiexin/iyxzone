class User::Guilds::RulesController < UserBaseController

  def index
    case params[:type].to_i
    when 0
      render :partial => 'edit_attendance_rules'
    when 1
      render :partial => 'edit_basic_rules'
    end   
  end

  def new
  end

  def create
    @rule = @guild.rules.build(params[:rule])
    if @rule.save
      render :update do |page|
        # insert a new row
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  # create new rules, or update existing rules 
  def create_or_update
    if @guild.update_attributes(params[:guild])
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

  def destroy
    if @rule.destroy
      render :update do |page|
        page << "$('rule_#{@rule.id}').remove;"
      end
    else
      render :update do |page|
        page << "error('发生错误，无法删除')"
      end
    end
  end

protected

  def setup
    if ["index", "new", "create_or_update"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
    elsif ["destroy"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
      @rule = @guild.rules.find(params[:id])
    end
  rescue
    not_found
  end

end
