require 'ferret'

namespace :mini_blogs do

  task :random => :environment do
    ids = MiniBlog.random(:limit => 100).map(&:id)
    # 如果审核不通过了怎么办
    MiniBlogMetaData.first.update_attributes(:random_ids => ids)
  end

  task :main_index => :environment do
    MiniBlog.build_main_index

    #`chown deployer:deployer #{RAILS_ROOT}/index/mini_blog -R`
  end

  task :delta_index => :environment do
    MiniBlog.build_delta_index 

    `chown deployer:deployer #{RAILS_ROOT}/index/mini_blog -R`
  end

  #
  # the following two might be slow
  # FIXME
  #  
  task :main_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    MiniTopic.destroy_all
    now = Time.now

    enum = reader.terms(:content)
    freqs = []
    terms = []
    enum.each do |term,freq|
      terms << term
      freqs << freq
    end
    sorted_freqs = freqs.sort{|a,b| b<=>a}

    terms.each_with_index do |term, i|
      freq = freqs[i]
      idx = sorted_freqs.index freq
      word = RMMSeg::Dictionary.get_word term
      if word.nil?
        if term =~ /[a-zA-Z0-9]+/ and !(term =~ /\d+/)
          topic = MiniTopic.create :name => term
          topic.add_node freq, (idx+1), now
        end
      else
        if word.cx_game? or (word.cx_noun? and word.freq < 1000000)
          topic = MiniTopic.create :name => term
          topic.add_node freq, (idx+1), now
        end
      end
    end
    e = Time.now

    #`chown deployer:deployer #{RAILS_ROOT}/index/mini_blog -R`
    puts "main_topics #{e-now} s"
  
    puts "now compute rank"
    s = Time.now
    meta_data = MiniBlogMetaData.first
    hot_topics = []
    range = [6.hours.ago, 1.day.ago, 2.day.ago, 7.day.ago]
    range.each do |from|
      to = Time.now
      topics = MiniTopic.hot_within(from ,to)
      hot_topics << topics[0..49].map{|a| [a[0], a[1].name]}
    end
    meta_data.hot_topics = hot_topics
    meta_data.save
    e = Time.now
    puts "rank #{e-s} s"
  end

  task :delta_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    now = Time.now

    enum = reader.terms(:content)
    freqs = []
    terms = []
    enum.each do |term,freq|
      terms << term
      freqs << freq
    end
    sorted_freqs = freqs.sort{|a,b| b<=>a}

    terms.each_with_index do |term, i|
      freq = freqs[i]
      idx = sorted_freqs.index freq
      word = RMMSeg::Dictionary.get_word term
      topic = MiniTopic.find_by_name term
      if topic.blank?
        if word.nil?
          if term =~ /[a-zA-Z0-9]+/ and !(term =~ /\d+/)
            topic = MiniTopic.create :name => term
            topic.add_node freq, (idx+1), now
          end
        else
          if word.cx_game? or (word.cx_noun? and word.freq < 1000000)
            topic = MiniTopic.create :name => term
            topic.add_node freq, (idx+1), now
          end
        end
      else
        topic.add_node freq, (idx+1), now
      end
    end
		`chown deployer:deployer #{RAILS_ROOT}/index/mini_blog -R`
    e = Time.now
    puts "delta topics #{e-now} s"
    puts "now compute rank"
    s = Time.now
    meta_data = MiniBlogMetaData.first
    hot_topics = []
    range = [6.hours.ago, 1.day.ago, 2.day.ago, 7.day.ago]
    range.each do |from|
      to = Time.now
      topics = MiniTopic.hot_within from ,to
      hot_topics << topics[0..49].map{|a| [a[0], a[1].name]}
    end
    meta_data.hot_topics = hot_topics
    meta_data.save   
    e = Time.now
    puts "rank #{e-s} s"
  end

end
