require 'ferret'
require 'lib/mini_blog_analyzer'

namespace :ferret do

  task :load => :environment do
    puts RMMSeg::Dictionary.load_dictionaries
  end

  task :gujian => :environment do
    RMMSeg::Dictionary.load_dictionaries
    a = MiniBlogAnalyzer.new
    i = Ferret::Index::Index.new :analyzer => a
    i << {:c => "南非世界杯开始了"}
  end

  task :build_main_index => :environment do
    configs = YAML::load(File.read("#{RAILS_ROOT}/config/ferret.yml"))
    configs.each do |model_name, config|
      index = LocalIndex.new model_name, config
      index.build_main_index
    end
  end

  task :build_delta_index => :environment do
    configs = YAML::load(File.read("#{RAILS_ROOT}/config/ferret.yml"))
    configs.each do |model_name, config|
      index = LocalIndex.new model_name, config
      index.build_delta_index
    end
  end

end
