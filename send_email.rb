require 'net/smtp'

def pl text
  puts "-------------------- #{text} --------------------"
end

gmail_setting = {
  :address => "smtp.gmail.com",
  :port => 587,
  :enable_starttls_auto => true,
  :domain => "17gaming.com",
  :authentication => :plain,
  :user_name => "daye@17gaming.com",
  :password => "20041065"
}

local_setting = {
  :address => "localhost",
  :port => 25,
  :enable_starttls_auto => true,
  :domain => "17gaming.com",
  :authentication => :plain,
  :user_name => "deployer",
  :password => "20041065"
}

mails = {
  :hotmail => {
    :user_name => 'dashaozi@hotmail.com',
    :password => '741852963'
  },
  :netease => {
    :user_name => 'silentdai@163.com',
    :password => 'hardworking'
  },
  :gmail => {
    :user_name => 'gaoxh04@gmail.com',
    :password => '20041065'
  },
  :yahoo_com_cn => {
    :user_name => 'gaoxiahong1020@yahoo.com.cn',
    :password => '861020' 
  },
  :sina_cn => {
    :user_name => 'gaoxh05@sina.com.cn',
    :password => '20041065'
  },
  :sina => {
    :user_name => 'silentdai@sina.com',
    :password => 'hardworking'
  }
}

def send_mails setting, mails, msg
  smtp = Net::SMTP.new(setting[:address], setting[:port])
  smtp.enable_starttls_auto
  mails.each do |name, recipient|
    pl "测试#{name}邮箱"
    smtp.start(setting[:domain], setting[:user_name], setting[:password], setting[:authenticiation]) do |smtp|
      smtp.send_mail msg, setting[:user_name], recipient[:user_name]
    end
  end
end

if ARGV[0] == 'gmail'
  send_mails gmail_setting, mails, 'helo from gmail'
else
  send_mails local_setting, mails, 'helo from postfix'
end
