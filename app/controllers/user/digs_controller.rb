class User::DigsController < UserBaseController

  def create
    @dig = Dig.new((params[:dig] || {}).merge(:poster_id => current_user.id))
    if @dig.save
      render :update do |page|
        page << "tip('成功')"
        if params[:at] == 'sharing'
          page << "$('dig_sharing_#{@dig.diggable.id}').update( \"<a class='praise' href='javascript:void(0)'><strong><span>#{@dig.diggable.digs_count}</span></strong></a>\");"
        else
				  page << "$('dig_#{@dig.diggable.class.name.underscore}_#{@dig.diggable.id}').update(#{@dig.diggable.digs_count})"
				  page << "$('digging_#{@dig.diggable.class.name.underscore}_#{@dig.diggable.id}').update('<a href=\"#\">已赞</a>')"
        end 
      end
    else
      render :update do |page|
        page << "tip('已经赞过了！');"
      end
    end
  end

end
