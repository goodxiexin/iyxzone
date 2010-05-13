ActiveRecord::Base.class_eval do 

  named_scope :offset, lambda {|offset| {:offset => offset}}

  named_scope :match, lambda {|cond| {:conditions => cond}}

  named_scope :limit, lambda {|limit| {:limit => limit}}

  named_scope :order, lambda {|order| {:order => order}}

  named_scope :prefetch, lambda {|opts| {:include => opts}}

end
