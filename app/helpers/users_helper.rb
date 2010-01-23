module UsersHelper

  def email_login_url email
    # email肯定是合法的，不然不会在数据库里
    domain = email.split('@').last
    case domain
    when 'gmail.com' then "http://www.gmail.com"
    when 'yahoo.com.cn' then "http://www.yahoo.com.cn"
    when 'yahoo.com' then "http://www.yahoo.com"
    when 'hotmail.com' then "http://www.hotmail.com"
    else
      # guess
      "http://#{domain}"
    end
  end

end
