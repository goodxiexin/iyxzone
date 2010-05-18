class Forum < ActiveRecord::Base

  belongs_to :guild

  has_many :topics, :dependent => :destroy

  has_many :posts

end
