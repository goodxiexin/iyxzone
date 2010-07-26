class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => "User"

  acts_as_commentable

  acts_as_resource_feeds :recipients => lambda {|status| status.poster}

end

class ConvertEmotion < ActiveRecord::Migration
  def self.up
    puts "convert status"
    Status.all.each do |s|
      s.content = Emotion.reverse_parse s.content
      s.save
    end
    puts "convert comment"
    Comment.all.each do |c|
      c.content = Emotion.reverse_parse c.content
      c.save
    end
    puts "convert message"
    Message.all.each do |c|
      c.content = Emotion.reverse_parse c.content
      c.save
    end
    puts "convert mail"
    Mail.all.each do |c|
      c.content = Emotion.reverse_parse c.content
      c.save
    end
  end

  def self.down
  end
end
