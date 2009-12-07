class MessagesController < ApplicationController

	layout 'user'

  before_filter :login_required, :setup

  def index
    if params[:type].to_i == 0
      @mails = current_user.sent_mails.paginate :page => params[:page], :per_page => 10
      render :action => 'sent_index'
    else
      @mails = current_user.recv_mails.paginate :page => params[:page], :per_page => 10
      render :action => 'recv_index'
    end
  end

  def show
    Mail.update_all("read_by_recipient = 1", {:parent_id => @root_mail.id, :receiver_id => current_user.id})
  end

  def new
  end

  def create
    Mail.transaction do
      params[:mail][:recipients].split(%r{,\s*}).each do |recipient_name|
        recipient = current_user.friends.find_by_login(recipient_name)
        if recipient
          mail = Mail.create(params[:mail].merge({:sender_id => current_user.id, :receiver_id => recipient.id}))
          mail.update_attribute('parent_id', mail.id)
        end
      end
    end
    redirect_to mails_url(:type => 0)
  end

  def reply
    @new_mail = Mail.new(params[:mail])
    @new_mail.title = "回复: #{@root_mail.title}"
    @new_mail.sender_id = current_user.id
    @new_mail.receiver_id = (@root_mail.sender == current_user)? @root_mail.receiver_id : @root_mail.sender_id
    @new_mail.parent_id = @root_mail.id
    if @new_mail.save
      render :update do |page|
        page.insert_html :bottom, 'mails', :partial => 'mail', :object => @new_mail
        page << "$('mail[content]').value = '';"
      end
    else
      render :update do |page|
        page << "error('错误，请稍后重试');"
      end
    end
  end

  def destroy
    if params[:type].to_i == 0
      Mail.update_all("delete_by_sender = 1", {:parent_id => @root_mail.id, :sender_id => current_user.id})
    else
      Mail.update_all("delete_by_receiver = 1", {:parent_id => @root_mail.id, :receiver_id => current_user.id})
    end
    flash[:notice] = "删除成功"
    render :update do |page|
      page.redirect_to mails_url(:type => params[:type])
    end
  end

  def read_multiple
    @mails.each { |mail| Mail.update_all("read_by_receiver = 1", {:parent_id => mail.parent_id, :receiver_id => current_user.id}) }
    render :inline => "<%= \"totally #{current_user.recv_mails.count} mails \" %> | <%= \"#{current_user.unread_recv_mails.count} unread\" %>"
  end

  def unread_multiple
    @mails.each { |mail| Mail.update_all("read_by_receiver = 0", {:parent_id => mail.parent_id, :receiver_id => current_user.id}) }
    render :inline => "<%= \"totally #{current_user.recv_mails.count} mails \" %> | <%= \"#{current_user.unread_recv_mails.count} unread\" %>"
  end

  def destroy_multiple
    if params[:type].to_i == 0
      @mails.each { |mail| Mail.update_all("delete_by_sender = 1", {:parent_id => mail.parent_id, :sender_id => current_user.id}) }
    else
      @mails.each { |mail| Mail.update_all("delete_by_receiver = 1", {:parent_id => mail.parent_id, :receiver_id => current_user.id}) }
    end
    render :update do |page|
      flash[:notice] = "删除成功"
      page.redirect_to mails_url(:type => params[:type])
    end     
  end

  def auto_complete_for_mail_recipients
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:mail][:recipients]) }
    render :inline => "<%= auto_complete_result @friends, 'login' %>"
  end

protected
	
	def setup
		if ["read", "show", "reply"].include? params[:action]
			if params[:type].to_i == 0
				@mail = current_user.out_box.find(params[:id])
			else
				@mail = current_user.in_box.find(params[:id])
			end
			@conversation = @mail.conversation
		elsif ["read_multiple", "update_multiple", "destroy_multiple"].include? params[:action]
			if params[:type].to_i == 0
				@mails = current_user.out_box.find(params[:ids])
			else
				@mails = current_user.in_box.find(params[:ids])
			end	
		elsif ["new"].include? params[:action]
			@recipient = User.find(params[:recipient_id]) unless params[:recipient_id].blank?
		end
	rescue
		not_found
  end

end
