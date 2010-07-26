require 'ferret'

namespace :mini_blogs do

  task :test => :environment do
    RMMSeg::Dictionary.load_dictionaries
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

  task :analyze_topics => :environment do
    include Ferret
    MiniTopic.delete_all
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    reader.terms(:content).each do |term, freq|
      MiniTopic.create :name => term, :freq => freq
    end
  end

end
