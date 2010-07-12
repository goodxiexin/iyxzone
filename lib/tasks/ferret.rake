require 'ferret'
require 'lib/ferret_analyzer_ext'

def measure_time str, &block
  s = Time.now
  yield
  e = Time.now
  puts "#{e-s} seconds: #{str}"
end

namespace :ferret do

  task :test_init => :environment do
    measure_time "init 500 times" do
      500.times do |i|
        analyzer = Ferret::Analysis::ChineseAnalyzer.new
        index = Ferret::Index::Index.new :path => '/home/gaoxh04/iyxzone/index/mini_blog', :analyzer => analyzer
      end
    end
  end

  task :build_main_index => :environment do
    `rm -rf /home/gaoxh04/iyxzone/index/mini_blog/main` 
    analyzer = Ferret::Analysis::ChineseAnalyzer.new
    info = FerretInfo.find_by_model_name "MiniBlog"
    index = Ferret::Index::Index.new :path => '/home/gaoxh04/iyxzone/index/mini_blog/main', :analyzer => analyzer, :create_if_missing => true
    measure_time "build main index" do
      mini_blogs = MiniBlog.find(:all, :select => "id, content")
      mini_blogs.each do |mb|
        index << {:id => "#{mb.id}", :content => mb.content}
      end
      MiniBlog.update_all("index_state = 1")
      index.optimize
      index.close
      info.update_attributes(:main_max_doc_id => MiniBlog.maximum(:id))
      info.modified_indexes.destroy_all
    end
  end

  task :build_delta_index => :environment do
    `rm -rf /home/gaoxh04/iyxzone/index/mini_blog/delta`
    analyzer = Ferret::Analysis::ChineseAnalyzer.new
    info = FerretInfo.find_by_model_name "MiniBlog"
    main_index = Ferret::Index::Index.new :path => '/home/gaoxh04/iyxzone/index/mini_blog/main', :analyzer => analyzer
    # add those newly created to delta index
    measure_time "totally" do
    measure_time "newly created" do
      maximum_id = MiniBlog.maximum(:id)
      MiniBlog.find(:all, :select => "id, content", :conditions => "id > #{info.main_max_doc_id}").each do |mb|
        main_index << {:id => "#{mb.id}", :content => mb.content}
      end
      info.update_attributes :main_max_doc_id => maximum_id
    end
    measure_time "delete" do
      info.deleted_indexes.each do |idx|
        main_index.writer.delete :id, "#{idx.doc_id}"
      end
    end
    measure_time "update" do
      MiniBlog.find(:all, :select => "id, content", :conditions => {:index_state => 2}).each do |mb|
        main_index << {:id => mb.id, :content => mb.content}
      end
      main_index.close
    end
    info.modified_indexes.destroy_all
    end
  end

end 
