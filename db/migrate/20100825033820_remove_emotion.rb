class RemoveEmotion < ActiveRecord::Migration
  def self.up
    # convert mail
    puts "convert mail"
    Mail.all.each do |m|
      con = Emotion.reverse_parse m.content
      m.update_attributes :content => con if con != m.content
    end
    
    # convert comment and wall message
    puts "convert comment"
    Comment.all.each do |c|
      con = Emotion.reverse_parse c.content
      c.update_attributes :content => con if con != c.content
    end
    
    # convert instant message
    puts "convert message"
    Message.all.each do |m|
      con = Emotion.reverse_parse m.content
      m.update_attributes :content => con if con != m.content
    end
  end

  def self.down
  end
end
