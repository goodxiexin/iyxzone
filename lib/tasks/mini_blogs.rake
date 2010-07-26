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
  task :analyze_topics => :environment do
    include Ferret
    MiniTopic.delete_all
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    reader.terms(:content).each do |term, freq|
      word = RMMSeg::Dictionary.get_word(term)
      if word.nil?
        MiniTopic.create :name => term, :freq => freq if term =~ /[a-ZA-Z0-9_]+/
      elsif (word.cx_game? or ((word.cx_noun? or word.cx_unkown?) and word.freq < 10000000))
        MiniTopic.create :name => term, :freq => freq
      end
    end
  end

end
