class HotWord < ActiveRecord::Base

  serialize :keywords, Array

  named_scope :recent, :order => "created_at DESC"

  def search_key
    keywords.join("~")
  end

end
