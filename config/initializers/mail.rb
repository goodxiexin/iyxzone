ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "17gaming.com",
  :port => 25,
  :enable_starttls_auto => true,
  :domain => "17gaming.com",
  :authentication => :plain,
  :user_name => "deployer",
  :password => "20041065"
}
ActionMailer::Base.delivery_method = :activerecord
