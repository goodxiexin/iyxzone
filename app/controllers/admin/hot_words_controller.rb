class Admin::HotWordsController < AdminBaseController

  def index
    @words = HotWord.recent.all
  end

  def create
    @word = HotWord.new(params[:word])

    if @word.save
      redirect_to admin_hot_words_url
    else
      render :action => 'new'
    end
  end

  def edit
    @word = HotWord.find(params[:id])
  end

  def update
    @word = HotWord.find(params[:id])

    if @word.update_attributes(params[:word])
      redirect_to admin_hot_words_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @word = HotWord.find(params[:id])

    if @word.destroy
      redirect_to admin_hot_words_url
    end
  end

protected

  def setup
    if ["create", "update"].include? params[:action]
      @keywords = params[:word][:keywords].blank? ? [] : params[:word][:keywords].split(/\s+/)
      params[:word][:keywords] = @keywords
    end
  end

end
