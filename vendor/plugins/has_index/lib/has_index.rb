module HasIndex

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods

    def has_index opts={}

      cattr_accessor :index_opts

      self.index_opts = opts


      before_create :create_index

      before_update :update_index

      before_destroy :destroy_index   

      include HasIndex::InstanceMethods

      extend HasIndex::SingletonMethods
 
    end

  end

  module InstanceMethods

    def create_index
      self.index_state = 0
    end

    def update_index
      if self.index_state == 1 and index_columns_changed?
        DeletedIndex.create :model_name => "MiniBlog", :doc_id => self.id
        self.index_state = 0
      end
    end

    def destroy_index
      if self.index_state == 1
        DeletedIndex.create :model_name => "MiniBlog", :doc_id => self.id
      end
    end

    #
    # 被索引了？？
    #
    def indexed?
      self.index_state == 1
    end

  protected

    def index_columns_changed?
      changed = false
      self.class.index_opts[:select_fields].each do |column|
        changed ||= eval("self.#{column}_changed?")
      end
      changed
    end 

  end

  module SingletonMethods

    def deleted_indexes
      DeletedIndex.all(:conditions => {:model_name => self.name})
    end
    
    def background_indexer
      if @background_indexer.nil?
        @background_indexer = BackgroundIndexer.new self.name.underscore, self.index_opts
      end
      @background_indexer 
    end

    def build_main_index
      background_indexer.build_main_index
    end

    def build_delta_index
      background_indexer.build_delta_index
    end

    def indexer
      if @indexer.nil?
        @indexer = Ferret::Index::Index.new :path => "#{RAILS_ROOT}/index/mini_blog", :analyzer => MiniBlogAnalyzer.new
      end
      @indexer
    end

    # 这个是和will_paginate兼容的，比那个煞笔acts_as_ferret强多了
    def search *args
      query = args.first
      opts = args.extract_options!

      per_page = opts.delete(:per_page)
      per_page = per_page.nil? ? 20 : per_page.to_i
      opts[:limit] = per_page

      page = opts.delete(:page)
      page = page.nil? ? 1 : page.to_i
      opts[:offset] = (page - 1) * per_page

      # 目前默认field_infos里一定要有id      
      docs = indexer.search query, opts
      records = self.find(docs.hits.map{|hit| indexer.reader.get_document(hit.doc)[:id]})
      records = WillPaginate::Collection.create(page, per_page, docs.total_hits) do |pager|
        pager.replace records.to_a
      end
      records
    end

  end

end

ActiveRecord::Base.send(:include, HasIndex)

