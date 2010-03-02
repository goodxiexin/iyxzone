require 'socket'
require 'rubygems'
require 'uri'
require 'cgi'
require 'net/http'
require 'net/https'


class Msn
  attr_reader :contacts
  SERVER = 'messenger.hotmail.com'
  PORT = 1863

  NEXUS  = 'nexus.passport.com'
  SSH_LOGIN  = 'login.live.com/login2.srf'

  CURL = '/usr/bin/curl'

  def initialize(u, p)
    @trID = 1
    @username = u
    @password = p
  end

  def connect
    @sock = TCPSocket::new(SERVER, PORT)
    
    output "VER 1 MSNP8 CVR0\r\n"
    input

    output "CVR 2 0x0409 winnt 5.1 i386 MSNMSGR 14.0.8089.0726 msmsgs #{@username}\r\n"
    input

    output "USR 3 TWN I #{@username}\r\n"
    s = input

    ns = s.split(' ')[3]
    ip = ns.split(':').first
    port = ns.split(':').last
    
    @sock.close
    @sock = TCPSocket::new(ip, port)
    
    output "VER 1 MSNP8 CVR0\r\n"
    input

    output "CVR 2 0x0409 winnt 5.1 i386 MSNMSGR 14.0.8089.0726 msmsgs #{@username}\r\n"
    input

    output "USR 3 TWN I #{@username}\r\n"
    s = input
    challenge = s[(s.index('COMPACT') + 8)..(s.length - 1)]
    puts challenge

    http = Net::HTTP.new(NEXUS, 443)
    http.use_ssl = true
    
    s = http.get('/rdr/pprdr.asp', nil)
    puts s['PassportURLs']
    m = /DALogin=(.*),DAReg=/.match(s['PassportURLs'])
    login = m.captures.first 
    base = login.split('/').first
    path = "/#{login.split('/').last}"

    http = Net::HTTP.new(base, 443)
    http.use_ssl = true
    s = http.get(path, {"Authorization" => "Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in=#{URI.escape @username},pwd=#{URI.escape @password},#{challenge}\r\n"})
    m = /from-PP='(.*)',ru=/.match(s['Authentication-Info'])
    token = m.captures.first

    output "USR 4 TWN S #{token}\r\n"
    input

    output "SYN 0 0\r\n"
    parse_contacts
  end


  def rx_data
  end

  def grab
  end

  protected

  def output data
    @sock.write data
    @trID = @trID + 1
    puts ">>> #{@trID} #{data}"
  end

  def parse_contacts
    @contacts = []
    while true 
      s = @sock.gets
      puts s
      if m = /SYN[\s]+[\d]*[\s]+[\d]*[\s]+([\d]*)[\s]+[\d]/.match(s)
        @contact_length = m[1].to_i
        puts "--------------total length: #{@contact_length}--------------"
        break
      end
    end
    read_length = 0
    while read_length < @contact_length
      s = @sock.gets
      if contact_item = /LST[\s]+([a-zA-Z0-9_\.-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+)[\s]+([\S]*)(([\s]+[\d]+)+)/.match(s)
        @contacts << [contact_item[1], contact_item[3]]
 #       puts "nickname: #{@contacts[@contacts.length-1][0]}  email: #{@contacts[@contacts.length-1][1]}"
        read_length += 1
      end        
    end
    @sock.close
    #puts @contacts
  end

  def input
    str = @sock.recv(1000)
    puts "<<<  #{str}"
    str
  end

  def error_code
    case @code
    when 201:
        return 'Error: 201 Invalid parameter';
    when 217:
        return 'Error: 217 Principal not on-line';
    when 500:
        return 'Error: 500 Internal server error';
    when 540:
        return 'Error: 540 Challenge response failed';
    when 601:
        return 'Error: 601 Server is unavailable';
    when 710:
        return 'Error: 710 Bad CVR parameters sent';
    when 713:
        return 'Error: 713 Calling too rapidly';
    when 731:
        return 'Error: 731 Not expected';
    when 800:
        return 'Error: 800 Changing too rapidly';
    when 910:
    when 921:
        return 'Error: 910/921 Server too busy';
    when 911:
        return 'Error: 911 Authentication failed';
    end
  end

end

#msn = Msn.new('gaoxh04@mails.tsinghua.edu.cn', '20041065')
#msn.connect
#puts msn.contacts.to_s
