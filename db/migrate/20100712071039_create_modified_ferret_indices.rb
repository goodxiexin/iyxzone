class CreateModifiedFerretIndices < ActiveRecord::Migration
  def self.up
    create_table :modified_ferret_indices do |t|
      t.integer :ferret_info_id
      t.integer :doc_id
      t.integer :category # update or delete
      t.string :in # in main index or delta index
    end
  end

  def self.down
    drop_table :modified_ferret_indices
  end
end
