class User::PokesController < UserBaseController

	layout 'app'

  def index
    @deliveries = current_user.poke_deliveries.paginate :page => params[:page], :per_page => 10
  end

  def new
    @recipient = User.find(params[:recipient_id])
    render :action => 'new', :layout => false
  end

  def create
    @delivery = PokeDelivery.new((params[:delivery] || {}).merge({:sender_id => current_user.id}))

    if @delivery.save 
      render :update do |page|
        page << "tip('发送成功');"
      end
    else
      render :update do |page|
        page << "error('你不能给他打招呼');" 
      end
    end
  end

  def destroy
    if @delivery.destroy
      render :update do |page|
        page << "$('poke_delivery_#{@delivery.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('删除错误，稍后再试');"
      end
    end
  end

  def destroy_all
		PokeDelivery.destroy_all(:recipient_id => current_user.id)
    flash[:notice] = "删除成功"
    redirect_to pokes_url
  end

protected

	def setup
		if ["destroy"].include? params[:action]
			@delivery = PokeDelivery.find(params[:id])
      require_owner @delivery.recipient
		end
	end

end
