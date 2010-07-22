class CreateDeletedIndices < ActiveRecord::Migration
  def self.up
    create_table :deleted_indices do |t|
      t.integer :doc_id
      t.string :model_name
    end
  end

  def self.down
    drop_table :deleted_indices
  end
end
