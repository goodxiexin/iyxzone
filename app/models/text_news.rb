class TextNews < News

  acts_as_abstract :columns => [:content]

end
