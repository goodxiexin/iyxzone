    require 'iconv'
    require 'net/http'
    puts ARGV
    url = ARGV[1] 
    uri = URI.parse(url)
    host = uri.host
    port = uri.port
    query = uri.query
    http = Net::HTTP.new(host, port)
    if uri.scheme.downcase == 'https'
      http.use_ssl = true
    end
    if path.blank?
      resp, body = http.get('/')
    else
      if query.blank?
        resp, body = http.get(path)
      else
        resp, body = http.get("#{path}/#{query}")
      end
    end
    if resp.is_a? Net::HTTPSuccess
      body =~ /<title>(.*?)<\/title>/
      title = url
      content_type = resp['Content-Type']
      content_type =~ /charset=(.*)/
      charset = url
      Iconv.iconv('utf8', charset, title)
    else
      url
    end

