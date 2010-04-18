class News < ActiveRecord::Base

  acts_as_shareable :path_reg => [/\/news\/([\d]+)/],
                    :default_title => lambda {|news| "新闻 #{news.title}"}

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, news, comment| user.has_role?('admin')}
                      
  acts_as_viewable

  acts_as_diggable

end
