# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 输出到tmp/cron_log
set :output, "#{RAILS_ROOT}/tmp/cron_log"

every :monday, :at => '3:00am' do
  rake "users:send_long_time_no_seen"
end

every 1.day, :at => '0:00am' do
  rake "events:send_approaching_notification"
end

every :tuesday, :at => '2:00am' do
  rake "feeds:delete_expired_deliveries"
end

every :wednesday, :at => '2:00am' do
  rake "games:update_last_week_characters_count"
end

every :wednesday, :at => '2:30am' do
  rake "games:update_last_week_attentions_count"
end

every 2.weeks, :at => '2:00am' do
  rake "tags:delete_unused_tags"
end

