require 'resolv'

class RegisterController < ApplicationController

	def new_character
	  @games = Game.find(:all, :order => 'pinyin ASC')
  end

  def validates_email_uniqueness
    if User.find_by_email params[:email].downcase
      render :json => {:code => 0}
    elsif valid_domain? params[:email].downcase
      render :json => {:code => 1}
    else
      render :json => {:code => 2}
    end
  end

  def validates_login_uniqueness
    if User.find_by_login params[:login].downcase
      render :json => {:code => 0}
    else
      render :json => {:code => 1}
    end
  end

  def invite
    @sender = SignupInvitation.find_sender(params[:token]) || User.find_by_invite_fan_code(params[:token]) || User.find_by_invite_code(params[:token]) || User.find_by_qq_invite_code(params[:token]) || User.find_by_msn_invite_code(params[:token])

    if @sender.blank?
      render_not_found
    else
      @as_fan = @sender.invite_fan_code == params[:token]
      @people = @as_fan ? @sender.fans[0..11] : @sender.friends[0..11]
      render :action => 'invite'  
    end
  end

protected

  def valid_domain?(email)
    domain = email.match(/(\S+)@(\S+)/)[2]
    dns = Resolv::DNS.new
    Timeout::timeout(3) do
      mx_records = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      mx_records.sort_by {|mx| mx.preference}.each do |mx|
        a_records = dns.getresources(mx.exchange.to_s, Resolv::DNS::Resource::IN::A)
        return true if a_records.any?
      end

      a_records = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      a_records.any?
    end
  rescue Timeout::Error, Errno::ECONNREFUSED
    false
  end

end
