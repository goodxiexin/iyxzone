class User::DigsController < UserBaseController

  def create
    @dig = Dig.new((params[:dig] || {}).merge(:poster_id => current_user.id))
    if @dig.save
      @diggable = @dig.diggable
      render :update do |page|
        if params[:at] == 'sharing'
          page << "$('dig_sharing_#{@diggable.id}').update( \"<a class='praise' href='javascript:void(0)'><strong><span>#{@diggable.digs_count}</span></strong></a>\");"
        else
          page << "$('dig_#{@diggable.class.name.underscore}_#{@diggable.id}').addClassName('dug');"
				  page << "$('dig_#{@diggable.class.name.underscore}_#{@diggable.id}').update(#{@diggable.digs_count})"
				  page << "Element.replace($('digging_#{@diggable.class.name.underscore}_#{@diggable.id}'), '<a href=\"javascript:void(0)\">赞</a>')"
        end 
      end
    else
      render :update do |page|
        page << "tip('已经赞过了！');"
      end
    end
  end

end
