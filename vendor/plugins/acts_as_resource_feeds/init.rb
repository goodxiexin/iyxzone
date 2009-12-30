require File.dirname(__FILE__) + '/lib/acts_as_resource_feeds'
ActiveRecord::Base.send(:include, ActsAsResourceFeeds)
