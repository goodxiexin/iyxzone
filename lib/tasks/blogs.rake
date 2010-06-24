namespace :blogs do

  desc "删除那些没用的博客图片"
  task :clear_orphan_blog_images => :environment do
    BlogImage.delete_all :blog_id => nil
  end

end
