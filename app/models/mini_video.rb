class MiniVideo < ActiveRecord::Base

  belongs_to :mini_blog

  acts_as_video

end
