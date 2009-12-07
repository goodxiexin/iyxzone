class DigsController < ApplicationController

  before_filter :login_required, :catch_diggable, :no_dug_required

  def create
    @diggable.digs.create(:poster_id => current_user.id)
    render :update do |page|
      page.alert "成功"
      page << "var el = $('dig_#{@diggable.class.to_s.underscore}_#{@diggable.id}'); var count = parseInt(el.innerHTML) + 1;el.innerHTML = count;"
    end
  end

protected

  def catch_diggable
  end

  def no_dug_required
    !@diggable.digged_by?(current_user) || no_dug_denied
  end

  def no_dug_denied
    render :update do |page|
      page << "alert('你只能挖一次');"
    end
  end

end
