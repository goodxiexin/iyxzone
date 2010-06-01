class User::FansController < UserBaseController

  def create
    @fanship = current_user.idolships.build(params[:fanship] || {})

    if @fanship.save
      render_js_code "alert('succ');"
    else
      render_js_error @fanship.errors.on(:idol_id)
    end
  end

  def destroy
    if @fanship.destroy
      render_js_code "alert('succ');"
    else
      render_js_error
    end 
  end

protected

  def setup
    if ['destroy'].include? params[:action]
      @fanship = Fanship.find(params[:id])
      require_delete_privilege @fanship
    end
  end

  def reqiure_delete_privilege fanship
    fanship.fan_id == current_user.id || fanship.idol_id = current_user.id || render_not_found
  end

end
