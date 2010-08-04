require 'ferret'

namespace :mini_blogs do

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
        if term =~ /[a-zA-Z0-9]+/
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
    puts "main topics #{e-now} s"
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
          if term =~ /[a-zA-Z0-9]+/
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

    e = Time.now
    puts "delta topics #{e-now} s"
  end

end
