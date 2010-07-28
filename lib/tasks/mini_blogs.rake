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

  #
  # FIXME: this might be quite slow
  #
  task :main_topics => :environment do
    include Ferret
    MiniTopic.delete_all
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    reader.terms(:content).each do |term, freq|
      word = RMMSeg::Dictionary.get_word term
      if word.nil?
        MiniTopic.create :name => term, :freq => freq if term =~ /[a-zA-Z0-9_]+/
      else
        if word.cx_game? or ((word.cx_unknown? or word.cx_noun?) and word.freq < 1000000)
          MiniTopic.create :name => term, :freq => freq
        end
      end
    end
  end

  task :delta_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    reader.terms(:content).each do |term, freq|
      word = RMMSeg::Dictionary.get_word term
      if word.nil?
        MiniTopic.create :name => term, :freq => freq if term =~ /[a-zA-Z0-9_]+/
      else
        if word.cx_game? or ((word.cx_unknown? or word.cx_noun?) and word.freq < 1000000)
          MiniTopic.create :name => term, :freq => freq
        end
      end
    end    
  end

end
