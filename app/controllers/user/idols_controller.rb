class User::IdolsController < UserBaseController

  layout 'app'

  def index
    @idols = User.match(:is_idol => true).order("fans_count DESC").paginate :page => params[:page], :per_page => 20
  end

  def follow
    @fanship = current_user.idolships.build(:idol_id => params[:id])

    unless @fanship.save
      render_js_error @fanship.errors.on(:idol_id)
    end
  end

  def unfollow
    @fanship = current_user.idolships.find_by_idol_id(params[:id])

    unless @fanship.destroy
      render_js_error
    end 
  end

end
