require "open-uri"
require "rss/1.0"
require "rss/2.0"

class RssFeed < ActiveRecord::Base

  class NotRssError < StandardError;  end

  belongs_to :user

  def parse
    content = open(link).read
    RSS::Parser.parse(content)
  rescue
    raise NotRssError, "连接不是有效的rss资源"
  end

  # 同步，返回新的rss feed
  # 当前的rss版本记录在last_update里
  def synchronize
    content = open(link).read
    css = RSS::Parser.parse(content)
    channel = css.channel
    items = css.items
    timestamp = items.first.date.to_datetime
    puts timestamp
    if timestamp > last_update
      new_items = items.select {|item| item.date.to_datetime > last_update}
      update_attributes(:last_update => timestamp)
      new_items
    else
      []
    end
  rescue
    destroy
  end

end
