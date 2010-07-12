class FerretInfo < ActiveRecord::Base

  validates_uniqueness_of :model_name

  def deleted_indexes
    modified_indexes.deleted
  end

  def updated_indexes
    modified_indexes.updated
  end

  has_many :modified_indexes, :class_name => "ModifiedFerretIndex", :dependent => :destroy

end
