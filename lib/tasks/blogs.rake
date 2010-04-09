namespace :blogs do

  desc "删除那些没用的博客图片"
  task :clear_orphan_blog_images => :environment do
    BlogImage.all.group_by(&:blog_id).map do |blog_id, images|
      if blog_id.blank?
        images.each do |image|
          image.destroy
        end
      else
        blog = Blog.find(blog_id)
        images.each do |image|
          image.destroy if image.updated_at != blog.updated_at # compare timestamps
        end
      end
    end
  end

end
