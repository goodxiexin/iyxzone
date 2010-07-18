require 'ferret'
require 'lib/mini_blog_analyzer'

namespace :index do

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

class LocalIndex

  def initialize model_name, config
    @model_class = model_name.to_s.camelize.constantize
    @path = "#{RAILS_ROOT}/index/#{model_name}"
    @config = config
    @query_step = @config[:query_step]   
 
    # init writer parameters
    @config[:writer] ||= {}
    if @config[:writer][:max_buffer_memory]
      @config[:writer][:max_buffer_memory] = @config[:writer][:max_buffer_memory] * 1024 * 1024
    end

    RMMSeg::Dictionary.load_dictionaries
    @config[:writer][:analyzer] = MiniBlogAnalyzer.new
    @config[:writer][:path] = @path

    # log file
    @logger = IndexLogger.instance
  
    # writer
    @writer = nil
  end

  def close
    @logger.close if @logger
    @writer.close if @writer
  end

  def build_main_index
    # delete existing index
    @writer = Ferret::Index::IndexWriter.new @config[:writer].merge({:create => true})
    @config[:field_infos].each do |field, attrs|
      @writer.field_infos.add_field field, attrs
    end
    
    measure_time "build main index for #{@model_class.name}" do
      maximum_id = @model_class.maximum(:id)
      cond = "id <= #{maximum_id}"
      count = @model_class.count(:conditions => cond)

      if @query_step.nil?
        @model_class.all(
          :conditions => cond, 
          :select => fields
        ).each do 
          @writer.add_document ar_to_doc(ar)
        end
      else
        with_step @query_step, count do |offset|
          @model_class.all(
            :conditions => cond, 
            :select => fields, 
            :limit => @query_step, 
            :offset => offset
          ).each do |ar|
            @writer.add_document ar_to_doc(ar)
          end
        end
      end

      @writer.optimize
      @writer.close

      @model_class.update_all("index_state = 1", "id <= #{maximum_id}")
    end
  end

  def build_delta_index
    @writer = Ferret::Index::IndexWriter.new @config[:writer]   
 
    measure_time "build delta index for #{@model_class.name}" do
      maximum_id = @model_class.maximum(:id)
      count = @model_class.count(:conditions => "id <= #{maximum_id} and index_state = 0")
      cond = "id <= #{maximum_id} and index_state = 0"
      
      #
      # 删除必须在前面，因为如果一个记录被更新了，那需要先删除，然后再创建
      #
      measure_time "unindexed deleted #{@model_class.deleted_indexes.count} records" do
        @model_class.deleted_indexes.each do |idx|
          @writer.delete :id, "#{idx.doc_id}"
        end
        DeletedIndex.delete_all :model_name => @model_class.name
      end

      measure_time "index newly created or newly updated records: #{count}" do
        if @query_step.nil?
          @model_class.all(
            :conditions => cond, 
            :select => fields
          ).each do |ar|
            @writer.add_document ar_to_doc(ar)
          end
        else
          with_step @query_step, count do |offset|
            @model_class.all(
              :conditions => cond, 
              :select => fields, 
              :limit => @query_step, 
              :offset => offset
            ).each do |ar|
                @writer.add_document ar_to_doc(ar)  
            end
          end
        end 
      end

      @writer.optimize
      @writer.close
    end

  end

protected

  def fields
    @config[:field_infos].keys.join(', ')
  end

  def with_step step, total, &block
    i = 0
    while i * step < total
      yield (i * step)
      i = i + 1
    end
  end

  def ar_to_doc ar
    doc = Ferret::Document.new
    @config[:field_infos].keys.each do |field|
      doc[field] = ar.read_attribute(field)
    end
    doc    
  end

  def measure_time str, &block
    s = Time.now
    yield
    e = Time.now
    puts "#{e-s} seconds: #{str}"
    @logger.log "[#{Time.now.strftime("%Y-%m-%d %H:%M")}]: #{e-s} seconds #{str}"
  end

end

class IndexLogger

  # 由于需要打开文件，所以用singleton设计模式，免除锁问题
  include Singleton

  def log msg
    @file.write "#{msg}\n"
  end

  def close
    @file.close
  end
  
  def initialize
    @file = File.open("#{RAILS_ROOT}/log/index.log", "a")
  end

end
