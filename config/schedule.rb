# 输出到tmp/cron_log
set :output, "#{RAILS_ROOT}/tmp/cron_log"

every 1.day, :at => '4:00am' do
  rake "backup:local"
end

every 2.weeks, :at => '4:30am' do
  rake "backup:s3"
end

every 1.day, :at => '0:00am' do
  rake "events:send_approaching_notification"
end

every 1.day, :at => '4:00am' do
  rake "users:verify_wow_characters"
  rake "users:verify_wowtw_characters"
end

every 1.week, :at => '2:30am' do
  rake "utils:tail_log"
end

every 2.weeks, :at => '2:00am' do
  rake "tags:delete_unused_tags"
end

every :monday, :at => '3:00am' do
  #rake "users:send_long_time_no_seen"
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

every :thursday, :at => '2:00am' do
  rake "blogs:clear_orphan_blog_images"
end

every :thursday, :at => '5:00am' do
  #rake "suggestions:create_friend_suggestions"
  #rake "suggestions:create_comrade_suggestions"
end

# 关于mini blog 
every 30.minutes do
  rake "mini_blogs:delta_index"
  rake "mini_blogs:analyze_topics"
end
