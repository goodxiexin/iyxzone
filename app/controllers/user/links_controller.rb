class User::LinksController < UserBaseController

  layout 'app'

  def create
    @link = Link.find_or_create(params[:link])
    render :json => @link
  end

end
