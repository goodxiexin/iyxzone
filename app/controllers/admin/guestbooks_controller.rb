class Admin::GuestbooksController < AdminBaseController

  def index
    @guestbooks = Guestbook.paginate :page => params[:page], :per_page => 20
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @guestbook.reply_to_poster params[:guestbook][:reply]
      render :update do |page|
        page << "var a = new Element('a', {href: 'javascript:void(0)'}).update('已经回复了');a.observe('click', function(e){facebox.set_width(350);tip('回复内容:<br/>#{@guestbook.reply}');});$('guestbook_#{@guestbook.id}').childElements()[2].update(a);"
        page << "facebox.close();"
      end
    else
      render_js_error
    end    
  end

  def destroy
    if @guestbook.destroy
      render :update do |page|
        page << "$('guestbook_#{@guestbook.id}').remove();"
      end
    else
      render_js_error
    end
	end

protected

  def setup
    if ['edit', 'update', 'destroy'].include? params[:action]
      @guestbook = Guestbook.find(params[:id])
    end
  end

end

