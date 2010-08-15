class User::IdolsController < UserBaseController

  layout 'app'

  def index
    @idols = User.match(:is_idol => true).all
  end

  def follow
    @fanship = current_user.idolships.build(:idol_id => params[:id])

    if @fanship.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0, :errors => @fanship.errors.on(:idol_id)}
    end
  end

  def follow_multiple
    params[:ids].each {|id| current_user.idolships.create :idol_id => id}
    render :json => {:code => 1}
    # TODO: error???
  end

  def unfollow
    @fanship = current_user.idolships.find_by_idol_id(params[:id])

    if @fanship.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0} 
    end 
  end

end
