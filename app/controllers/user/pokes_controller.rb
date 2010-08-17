class User::PokesController < UserBaseController

	layout 'app'

  def index
    @deliveries = current_user.poke_deliveries.paginate :page => params[:page], :per_page => 10, :include => [:sender]
  end

  def new
    @recipient = User.find(params[:recipient_id])
    @pokes = Poke.all
    render :action => 'new', :layout => false
  end

  def create
    @delivery = PokeDelivery.new((params[:delivery] || {}).merge({:sender_id => current_user.id}))

    if @delivery.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0, :errors => @delivery.errors}
    end
  end

  def destroy
    if @delivery.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy_all
		if PokeDelivery.delete_all_for current_user
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

	def setup
		if ["destroy"].include? params[:action]
			@delivery = PokeDelivery.find(params[:id])
      require_owner @delivery.recipient
		end
	end

end
