require 'resolv'

class RegisterController < ApplicationController

	def new_character
	  @games = Game.find(:all, :order => 'pinyin ASC')
  end

  def validates_email_uniqueness
    if User.find_by_email params[:email].downcase
      render :text => 'no'
    elsif valid_domain? params[:email].downcase
      render :text => 'yes'
    else
      render :text => 'domain_error'
    end
  end

  def invite
    @sender = SignupInvitation.find_sender(params[:token]) || User.find_by_invite_code(params[:token]) || User.find_by_qq_invite_code(params[:token]) || User.find_by_msn_invite_code(params[:token])

    if @sender.blank?
      render_not_found
    else
      @friends = @sender.friends[0..11]
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
