class Poll::AnswersController < ApplicationController

  before_filter :login_required, :setup

  before_filter :owner_required

  def new
  end
 
  def create
    params[:answers].each do |answer_attribute|
      @poll.answers.create(answer_attribute) unless answer_attribute[:description].blank?
    end
    render :update do |page|
      page << "facebox.close();"
      page.redirect_to poll_url(@poll)
    end
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    @user = @poll.poster
  rescue
    not_found
  end

end
