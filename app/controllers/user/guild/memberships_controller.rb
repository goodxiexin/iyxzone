class User::Guild::MembershipsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit]

  def index
		if params[:type].to_i == 0
			@members = @guild.veterans.paginate :page => params[:page], :per_page => 10
    elsif params[:type].to_i == 1
      @members = @guild.members.paginate :page => params[:page], :per_page => 10
    elsif params[:type].to_i == 2
      @members = @guild.invitees.paginate :page => params[:page], :per_page => 10
    elsif params[:type].to_i == 3
			@members = @guild.requestors.paginate :page => params[:page], :per_page => 10
		end
  end

  def edit
    render :action => 'edit', :layout => false  
  end
  
  def update
    @old_status = @membership.status
    if @membership.update_attributes(params[:membership])
      render :update do |page|
        page << "facebox.close();"
        if @old_status != @membership.status
          page << "$('membership_#{@membership.id}').remove();"
        end
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = '错误'"
      end
    end 
  end

  def destroy
    if @membership.destroy
      render :update do |page|
        page << "$('member_#{@membership.user_id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def search
		if params[:type].to_i == 0
      @members = @guild.veterans
    elsif params[:type].to_i == 1
      @members = @guild.member
    elsif params[:type].to_i == 2
      @members = @guild.invitees
    elsif params[:type].to_i == 3
      @members = @guild.requestors
    end 
		@members = @members.find_all {|m| m.login.include?(params[:key]) }.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    @remote = {:update => 'members', :url => search_guild_memberships_url(@guild, :type => params[:type], :key => params[:key])}
    if params[:type].to_i == 2
			render :partial => 'invitees', :object => @members
    elsif params[:type].to_i == 3
			render :partial => 'requestors', :object => @members
    else
			render :partial => 'members', :object => @members
    end
	end
 
protected

  def setup
    if ['index', 'search'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
      @membership = @guild.memberships.find(params[:id])
    end
  rescue
    not_found
  end

end
