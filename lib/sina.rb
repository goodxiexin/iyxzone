require 'net/http'
require 'socket'

s = Net::HTTP.new('mail.sina.com.cn')

# login
r = s.post('/cgi-bin/login.cgi', "logintype=uid&u=gaoxh05@sina.com.cn&psw=20041065", {"Referer" => "mail.sina.com.cn", "Content-Type" => "application/x-www-form-urlencoded", "Cookie" => "sina_free_mail_recid=false&sina_vip_mail_recid=false"})

# parse cookie and location
c = ''
l = ''
r.each_header do |k, v|
  c = v if k == 'set-cookie'
  l = v if k == 'location'
end

l = l.split('http://').last
l = l.split('/').first

puts "cookie: #{c}"
puts "redirected_to: #{l}"

s = Net::HTTP.new(l)

# fetch contacts
r = s.post('/classic/addr_member.php', "sort_item=letter&sort_type=desc&act=list&gid=6", {"Content-Type" => "application/x-www-form-urlencoded", "Cookie" => c})
puts r.body
