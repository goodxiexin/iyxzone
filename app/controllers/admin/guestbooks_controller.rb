class Admin::GuestbooksController < AdminBaseController

  # GET /admin/guestbooks
  def index
    @guestbooks = Guestbook.all
  end

  # GET /admin/guestbooks/1
  def show
    @guestbook = Guestbook.find(params[:id])
  end

  # GET /admin/guestbooks/1/edit
  def edit
    @guestbook = Guestbook.find(params[:id])
  end

=begin
  def update
    @guestbook = Guestbook.find(params[:id])

    if @guestbook.update_attributes(params[:guestbook])
      flash[:notice] = 'Guestbook was successfully updated.'
      redirect_to(admin_guestbook_url) 
    else
      render :action => "edit"
    end
  end
=end

  def update
    @guestbook = Guestbook.find(params[:id])

    if @guestbook.reply_to_poster params[:reply]
      flash[:notice] = 'Guestbook was successfully updated.'
      redirect_to(admin_guestbook_url) 
    else
      render :action => "edit"
    end    
  end

  # DELETE /admin/guestbooks/1
  def destroy
    @guestbook = Guestbook.find(params[:id])
    @guestbook.destroy
		redirect_to(guestbooks_url) 
	end

end

