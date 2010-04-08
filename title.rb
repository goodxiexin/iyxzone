require 'net/http'
require 'uri'
require 'iconv'
  def fetch(uri_str, limit = 5)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    resp, body = Net::HTTP.get_response(URI.parse(uri_str))
    puts resp.to_s
    if resp.is_a? Net::HTTPSuccess
      [resp, body]
    elsif resp.is_a? Net::HTTPRedirection
      puts "redirect: #{resp['location']}"
      fetch(resp['location'], limit - 1)
    elsif resp.is_a? Net::HTTPMovedPermanently
      puts "permanently: #{resp['location']}"
      fetch(resp['location'], limit - 1)
    else
      raise ArgumentError, 'invalid url'
    end
  end

resp, body = fetch('http://ruby.about.com/od/rubyfeatures/a/argv.htm')
body =~ /<title>(.*?)<\/title>/
      title = $1
      content_type = resp['Content-Type']
      content_type =~ /charset=(.*)/
      charset = $1
      Iconv.iconv('utf8', charset, title)

