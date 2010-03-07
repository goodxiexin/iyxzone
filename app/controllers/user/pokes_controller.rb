class User::PokesController < UserBaseController

	layout 'app'

  def index
    @deliveries = current_user.poke_deliveries.paginate :page => params[:page], :per_page => 10
  end

  def new
		@pokes = Poke.all
    @recipient = User.find(params[:id])
    render :action => 'new', :layout => false
  end

  def create
    @recipient = User.find(params[:delivery][:recipient_id])
    @poke = Poke.find(params[:delivery][:poke_id])

    if @recipient.poke_deliveries.create(params[:delivery].merge({:sender_id => current_user.id}))
      render :update do |page|
        page << "facebox.close();"
      end
    else
      render :update do |page|
        page << "error('发生错误，稍后再试');" 
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
