class ModifiedFerretIndex < ActiveRecord::Base

  named_scope :deleted, :conditions => {:category => 0}

  named_scope :updated, :conditions => {:category => 1}

end
