class HotWord < ActiveRecord::Base

  serialize :keywords, Array

  named_scope :recent, :order => "created_at DESC"

  def search_key
    keywords.join("~")
  end

  # TODO: this is slow and ugly
  def freq
    MiniBlog.indexer.search("content: (#{keywords.join(" ")})").total_hits
  end

end
