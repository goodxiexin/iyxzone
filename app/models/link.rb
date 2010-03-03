class Link < ActiveRecord::Base

  acts_as_shareable :default_title => lambda {|link| link.url}

  before_create :modify_url
  
  def modify_url
    unless self.url.starts_with? 'http://'
      self.url = "http://#{self.url}"
    end
  end

  validates_presence_of :url, :message => "不能为空", :on => :create

  validates_format_of :url, :with => /(http:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-%=&]+)?/, :on => :create, :message => '不是合法的url'

end
