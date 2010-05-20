class User::DigsController < UserBaseController

  def create
    if @diggable.dug_by current_user
      @diggable.reload # reload is mandatory, otherwise digs_count is not uptodate
    else
      render_js_error
    end
  end

protected

  def setup
    @diggable = params[:diggable_type].constantize.find(params[:diggable_id])
    require_verified @diggable if @diggable.respond_to?(:verified)
  end  

end
