require 'json'

class Contacts

  class Sina < Base

    URL         = "http://mail.sina.com.cn/"
    LOGIN_URL   = "http://mail.sina.com.cn/cgi-bin/login.cgi"
    
    def real_connect
      postdata = "logintype=uid&u=#{CGI.escape("gaoxh05@sina.com.cn")}&psw=#{CGI.escape("20041065")}"

      data, resp, cookies, forward = post(LOGIN_URL, postdata, "sina_free_mail_recid=false&sina_vip_mail_recid=false", "mail.sina.com.cn")
      #puts "code: #{resp.code}"
      #puts ""
      #puts cookies
      #puts ""
      puts "forward: #{forward}"

      data, resp, cookies, forward = get(forward, cookies, LOGIN_URL) 
      #puts "code: #{resp.code}"
      #puts "" 
      #puts cookies
      #puts ""
      puts "forward: #{forward}"
   
      data, resp, cookies, forward = get(forward, cookies, forward)
      #puts "code: #{resp.code}"
      #puts ""
      #puts cookies
      #puts ""
      p1 = resp.body.index('contacts:')
      p2 = resp.body.index('groups:', p1)
      contacts_str = resp.body[(p1+9)..(p2-5)]
      contacts_str.gsub!("&quot;", '"')
      JSON.parse(contacts_str)
      puts resp.body
      puts "contacts: #{contacts_str}"
      
=begin 
      http = open_http(URI.parse(forward))
      resp, data = http.post("/classic/addr_member.php", "sort_item=letter&sort_type=desc&act=list&gid=6", {"Cookie" => cookies})
      puts "code: #{resp.code}"
      puts "body: #{resp.body}"
=end
    end

    def contacts
    end

  private
  
  end  
  
  TYPES[:sina] = Sina

end 
