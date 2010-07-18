require 'ferret'

namespace :mini_blogs do

  task :random => :environment do
    ids = MiniBlog.random(:limit => 100).map(&:id)
    # 如果审核不通过了怎么办
    MiniBlogMetaData.first.update_attributes(:random_ids => ids)
  end

  task :main_index => :environment do
    configs = YAML::load(File.read("#{RAILS_ROOT}/config/ferret.yml"))
    if configs[:mini_blog]
      index = MiniBlogIndex.new :mini_blog, configs[:mini_blog]
      index.build_main_index
    else
      puts "config/ferret.yml 不包含 mini_blog信息"
    end
  end

  task :delta_index => :environment do
    configs = YAML::load(File.read("#{RAILS_ROOT}/config/ferret.yml"))
    if configs[:mini_blog]
      index = MiniBlogIndex.new :mini_blog, configs[:mini_blog]
      index.build_delta_index
    else
      puts "config/ferret.yml 不包含 mini_blog信息"
    end
  end

  task :analyze_topics => :environment do
    include Ferret
    reader = Index::IndexReader.new "#{RAILS_ROOT}/index/mini_blog"    
    reader.terms(:content).each do |term, freq|
      topic = MiniTopic.find_by_name term
      if topic
        topic.update_attributes :freq => freq
      else 
        MiniTopic.create :name => term, :freq => freq
      end
    end
  end

end

class MiniBlogIndex < LocalIndex

protected

  def ar_to_doc ar
    doc = Ferret::Document.new
    doc[:id] = ar.id
    doc[:content] = []
    # only text nodes, topic nodes and ref nodes are considered
    ar.nodes.each do |n|
      if n[:type] == 'text'
        doc[:content] << n[:val]
      elsif n[:type] == 'topic'
        doc[:content] << n[:name]
      elsif n[:type] == 'ref'
        doc[:content] << n[:login]
      end
      puts doc[:content].join(', ')
    end
    doc
  end

  def fields
    "id, nodes"
  end

end
