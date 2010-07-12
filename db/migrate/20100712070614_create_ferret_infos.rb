class CreateFerretInfos < ActiveRecord::Migration
  def self.up
    create_table :ferret_infos do |t|
      t.string :model_name
      t.integer :main_max_doc_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ferret_infos
  end
end
