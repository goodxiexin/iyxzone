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
      # 由于历史问题，profile和user里都有login，修改profile的login会同时修改user的login
      @user = @record.user
      @profile = @user.profile
      @profile.login = params[:login]
      if @profile.save
        @record.destroy
        render :json => {:code => 1}
      else
        if @profile.errors.on(:login)
          render :json => {:code => 2} 
        else
          render :json => {:code => 3}
        end
      end  
    end
  end

  def validates_login_uniqueness
    @record = InvalidName.find_by_token(params[:nickname_code])   

    if @record.nil?
      render_not_found
    else
      @user = @record.user
      @users = User.match(:login => (params[:login] || "").downcase).all
      if @users.blank? or (@users == [@user])
        render :json => {:code => 1}
      else
        render :json => {:code => 0}
      end  
    end 
  end

end
