class User::DigsController < ApplicationController

  before_filter :login_required, :setup

  def create
    #
    # tip: 
    # 如果这里用@diggable.digs.create而且用户已经dig过了，那么
    # @diggable.digs.create会返回一个id = nil的dig record，仍然相当于true
    # 这可以在script/console里得到验证
    #
    @dig = @diggable.digs.build(:poster_id => current_user.id)
    if @dig.save
      render :update do |page|
        page << "tip('成功')"
        page << "$('dig_#{@diggable.class.to_s.underscore}_#{@diggable.id}').innerHTML = #{@diggable.digs_count + 1}"
      end
    else
      render :update do |page|
        page << "tip('你只能挖一次');"
      end
    end
  end

protected

  def setup
    if ['create'].include? params[:action]
      @diggable = get_diggable
    end
  rescue
    not_found
  end

  def get_diggable
    @klass = params[:diggable_type].camelize.constantize
    @klass.find(params[:diggable_id])
  rescue
    not_found
  end

end
