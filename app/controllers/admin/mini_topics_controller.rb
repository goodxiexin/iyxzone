class Admin::MiniTopicsController < AdminBaseController

  def new
    @reader = MiniBlog.indexer.reader
    @count = @reader.term_count :content
    @terms = @reader.terms(:content)
  end

  def create
    @topic = MiniTopic.new :name => params[:term], :freq => params[:freq]

    if @topic.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end  
  end

end
