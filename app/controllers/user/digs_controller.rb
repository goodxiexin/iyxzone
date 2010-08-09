class User::DigsController < UserBaseController

  def create
    if @diggable.dug_by current_user
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    @diggable = params[:diggable_type].constantize.find(params[:diggable_id])
    require_verified @diggable if @diggable.respond_to?(:rejected?)
  end  

end
