require 'json'
require 'rexml/document'

class Contacts

  class Netease < Base

    include REXML

    URL         = "http://mail.163.com/"
    LOGIN_URL   = "http://reg.163.com/login.jsp?type=1&url=http://entry.mail.163.com/coremail/fcg/ntesdoor2?" + CGI.escape("lightweight%3D1%26verifycookie%3D1%26language%3D-1%26style%3D-1")
    ENTRY_URL   = "http://entry.mail.163.com/coremail/fcg/ntesdoor2?lightweight=1&verifycookie=1&language=-1&style=1&username="
    REQUEST_PARAM = "&func=global:sequential"
    XML_CONTACT_REQUEST = '<?xml version="1.0"?><object><array name="items"><object><string name="func">pab:searchContacts</string><object name="var"><array name="order"><object><string name="field">FN</string><boolean name="ignoreCase">true</boolean></object></array></object></object><object><string name="func">user:getSignatures</string></object><object><string name="func">pab:getAllGroups</string></object></array></object>'
    DEBUG = true


    def real_connect
      postdata = "type=1&url=#{CGI.escape("http://entry.mail.163.com/coremail/fcg/ntesdoor2?lightweight%3D1%26verifycookie%3D1%26language%3D-1%26style%3D-1")}" + "verifycookie=1&style=1&product=mail163&savelogin=&url2=#{CGI.escape("http%3A%2F%2Fmail.163.com%2Ferrorpage%2Ferr_163.htm")}&username=#{@login}&password=#{@password}&selType=js35"
      puts "-------------------------------------------"
      puts LOGIN_URL
      puts "dycpostdata:\t" + postdata
      data, resp, cookies, forward = post(LOGIN_URL, postdata, "", "mail.163.com")
      if m  = /errorType=([\d]{3})/.match(CGI.unescape(data))
        error_code(m[1].to_i)
      end

      forward = ENTRY_URL + login.split('@').first
      data, resp, cookies, forward = get(forward, cookies, LOGIN_URL) 
      contacturl = forward.gsub(/\/main\.jsp/, '/s') + REQUEST_PARAM
      postdata = XML_CONTACT_REQUEST
      @data, resp , cookies, forward = my_Post(contacturl, postdata, cookies, forward)
      puts "response: #{resp}"
      puts "SHOULD print contact list below!---------------------------"
      puts "Data:\n #{data}"
      
    end

    def contacts
      @contact = []
      doc = Document.new @data
      root = doc.root.elements["array/object/array"]
      root.elements.each("object") do |person|
        pnick = nil
        pemail = nil
        person.elements.each('string') do |el|
          if el.attributes['name'] == 'EMAIL;PREF'
            pemail = el.text	
          end
          if el.attributes['name'] == 'FN'
            pnick = el.text
          end
        end
        if pemail && !pnick
          pnick = pemail
        end
        @contact << [pnick, pemail] if pemail
      end
      @contact

    end

    private

    def my_Post(url, postdata, cookies="", referer="",contenttype='xml',charset='UTF-8')
      url = URI.parse(url)
      http = open_http(url)
      puts "--------------------In my_Post----------------"
      puts "#{url.path}?#{url.query}"
      resp, data = http.post("#{url.path}?#{url.query}", postdata,
                             "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0",
                             "Accept-Encoding" => "gzip",
                             "Cookie" => cookies,
                             "Referer" => referer,
                             #"Content-Type" => 'application/x-www-form-urlencoded',
                             "Content-Type" => "application/#{contenttype}; charset=#{charset}"
                             )
      data = uncompress(resp, data)
      cookies = parse_cookies(resp.response['set-cookie'], cookies)
      forward = resp.response['Location']
      forward ||= (data =~ /<meta.*?url='([^']+)'/ ? CGI.unescapeHTML($1) : nil)
      if (not forward.nil?) && URI.parse(forward).host.nil?
        forward = url.scheme.to_s + "://" + url.host.to_s + forward
      end
      return data, resp, cookies, forward
    end
    def error_code (error)
      case error
      when 420, 460:
        raise AuthenticationError, "用户名密码错误";
      when 422:
        raise AuthenticationError, "此帐号已被锁定";
      when 412..419:
        raise ConnectionError, "登录操作过于频繁";
      when 500, 503:
        raise ConnectionError, "系统繁忙";
      else
        raise ConnectionError, "UnkownError"
      end
    end
  end  

    
  TYPES[:netease] = Netease

end 
