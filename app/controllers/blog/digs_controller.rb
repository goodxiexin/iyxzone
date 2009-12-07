class Blog::DigsController < DigsController

	before_filter :privilege_required

protected

  def catch_diggable
    @blog = Blog.find(params[:blog_id])
		@user = @blog.poster
		@privilege = @blog.privilege
    @diggable = @blog
  rescue
    not_found
  end

end
