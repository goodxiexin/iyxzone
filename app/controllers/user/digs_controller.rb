class User::DigsController < UserBaseController

  def create
    @dig = Dig.new((params[:dig] || {}).merge(:poster_id => current_user.id))
    if @dig.save
      render :update do |page|
        page << "tip('成功')"
        page << "$('dig_#{params[:dig][:diggable_type].underscore}_#{params[:dig][:diggable_id]}').innerHTML = #{@dig.diggable.digs_count}"
      end
    else
      render :update do |page|
        page << "tip('#{@dig.errors.on_base}');"
      end
    end
  end

end
