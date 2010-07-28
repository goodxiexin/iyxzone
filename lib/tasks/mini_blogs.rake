require 'ferret'

namespace :mini_blogs do

  task :test => :environment do
    RMMSeg::Dictionary.load_dictionaries
    w = RMMSeg::Dictionary.get_word "海涛"
    puts "word: #{w.text}, freq: #{w.freq}, cixing: #{w.cixing}"
  end

  task :random => :environment do
    ids = MiniBlog.random(:limit => 100).map(&:id)
    # 如果审核不通过了怎么办
    MiniBlogMetaData.first.update_attributes(:random_ids => ids)
  end

  task :main_index => :environment do
    MiniBlog.build_main_index
  end

  task :delta_index => :environment do
    MiniBlog.build_delta_index 
  end

  
  task :main_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    MiniTopic.destroy_all
    now = Time.now
    reader.terms(:content).each do |term, freq|
      word = RMMSeg::Dictionary.get_word term
      if word.nil?
        if word =~ /[a-zA-Z0-9]+/
          topic = MiniTopic.create :name => term
          topic.add_node freq, now
        end
      else
        if word.cx_game? or (word.cx_noun? and word.freq < 1000000)
          topic = MiniTopic.create :name => term
          topic.add_node freq, now
        end
      end
    end
    e = Time.now
    puts "#{e-now} s"
  end

  task :delta_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    now = Time.now
    reader.terms(:content).each do |term, freq|
      word = RMMSeg::Dictionary.get_word term
      topic = MiniTopic.find_by_name term
      if topic.blank?
        if word.nil?
          if word =~ /[a-zA-Z0-9]+/
            topic = MiniTopic.create :name => term
            topic.add_node freq, now
          end
        else
          if word.cx_game? or (word.cx_noun? and word.freq < 1000000)
            topic = MiniTopic.create :name => term
            topic.add_node freq, now
          end
        end
      else
        if freq != topic.freq
          topic.add_node freq, now
        end
      end
    end
    e = Time.now
    puts "#{e-now} s"
  end

end
