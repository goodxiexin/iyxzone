#
# 用来在后台生成索引的
# 其实就是封装了Ferret的Indexer类
# 主要是为了实现主索引和增量索引
#
module HasIndex

class BackgroundIndexer

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

    #RMMSeg::Dictionary.load_dictionaries
    @config[:writer][:analyzer] = ChineseAnalyzer.new
    @config[:writer][:path] = @path

    # writer
    @writer = nil
  end

  def close
    @writer.close if @writer
  end

  def build_main_index
    # delete existing index
    @writer = Ferret::Index::IndexWriter.new @config[:writer].merge({:create => true})
    @config[:field_infos].each do |field, attrs|
      @writer.field_infos.add_field field, attrs
    end
    
    maximum_id = @model_class.maximum(:id)

    if maximum_id.blank?
      return
    end

    cond = "id <= #{maximum_id}"
    count = @model_class.count(:conditions => cond)

    if @query_step.nil?
      @model_class.all(
          :conditions => cond, 
          :select => fields
        ).each do
        @writer.add_document ar.to_doc
      end
    else
      with_step @query_step, count do |offset|
        @model_class.all(
            :conditions => cond, 
            :select => fields, 
            :limit => @query_step, 
            :offset => offset
          ).each do |ar|
          @writer.add_document ar.to_doc
        end
      end
    end

    DeletedIndex.delete_all :model_name => @model_class.name

    @writer.optimize
    @writer.close

    @model_class.update_all("index_state = 1", "id <= #{maximum_id}")
  end

  def build_delta_index
    @writer = Ferret::Index::IndexWriter.new @config[:writer]   
 
    maximum_id = @model_class.maximum(:id)
      
    if maximum_id.blank?
      return
    end

    count = @model_class.count(:conditions => "id <= #{maximum_id} and index_state = 0")
    cond = "id <= #{maximum_id} and index_state = 0"
      
    #
    # 删除必须在前面，因为如果一个记录被更新了，那需要先删除，然后再创建
    #
    @model_class.deleted_indexes.each do |idx|
      @writer.delete :id, "#{idx.doc_id}"
    end
    DeletedIndex.delete_all("model_name = '#{@model_class.name}' AND id <= #{maximum_id}")
        
    if @query_step.nil?
      @model_class.all(
        :conditions => cond, 
        :select => fields
      ).each do |ar|
        @writer.add_document ar.to_doc
      end
    else
      with_step @query_step, count do |offset|
        @model_class.all(
          :conditions => cond, 
          :select => fields, 
          :limit => @query_step, 
          :offset => offset
        ).each do |ar|
            @writer.add_document ar.to_doc
        end
      end
    end
    @model_class.update_all("index_state = 1", "id <= #{maximum_id}")
    
    @writer.optimize
    @writer.close
  end

protected

  def fields
    if @config[:select_fields]
      @config[:select_fields].join(', ')
    else
      @config[:field_infos].keys.join(', ')
    end
  end

  def with_step step, total, &block
    i = 0
    while i * step < total
      yield (i * step)
      i = i + 1
    end
  end

end

end
