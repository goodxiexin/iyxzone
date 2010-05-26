ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :enable_starttls_auto => true,
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "xiexinwang",
  :password => "JJK78ytx"
}
ActionMailer::Base.delivery_method = :activerecord
