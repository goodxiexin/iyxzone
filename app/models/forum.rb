class Forum < ActiveRecord::Base

  belongs_to :guild

  has_many :topics, :dependent => :destroy, :order => "created_at DESC"

  has_many :posts

end
