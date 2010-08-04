class NicknameController < ApplicationController

  layout 'root'

  def edit
    @record = InvalidName.find_by_token(params[:nickname_code])   

    if @record.nil?
      render_not_found
    else
      @user = @record.user
    end
  end

  def update
    @record = InvalidName.find_by_token(params[:nickname_code])   

    if @record.nil?
      render_not_found
    else
      @user = @record.user
      @user.login = params[:login]
      if @user.save
        flash[:notice] = "昵称修改成功"
        redirect_to login_path
      else
        if @user.errors.on(:login)
          flash.now[:error] = "该昵称已经被注册"
          render :action => 'edit'
        else
          flash.now[:error] = "发生错误，稍后再试"
          render :action => 'edit'
        end
      end  
    end
  end

end
