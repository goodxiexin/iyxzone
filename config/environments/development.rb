# Settings specified here will take precedence over those in config/environment.rb
<<<<<<< HEAD:config/environments/development.rb
SITE_URL = "http://localhost:3000"
=======
SITE_URL = "http://192.168.217.3:3000"
>>>>>>> 59331bfa18927a908bbb2d256cd4a95c5981df00:config/environments/development.rb
SITE_MAIL = "gaoxh04@gmail.com"

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
