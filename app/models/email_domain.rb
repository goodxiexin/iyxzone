require 'resolv'

class EmailDomain < ActiveRecord::Base

  validates_uniqueness_of :domain

  def self.valid? email
    domain = email.match(/(\S+)@(\S+)/)[2]
    
    # try to validate from database
    record = EmailDomain.find_by_domain domain
    return true if !record.nil?
      
    # if not exists in database, check dns to see if domain is valid
    if validate_dns domain
      EmailDomain.create :domain => domain, :validated_at => Time.now
      true
    else
      false
    end
  end

  def self.validate_dns domain
    #domain = email.match(/(\S+)@(\S+)/)[2]
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
