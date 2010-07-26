class AddIndexState < ActiveRecord::Migration
  def self.up
    # 0: unindexed, 1: indexed in main, 2: indexed in delta, 3: updated in main index, 4: updated in delta index, 5: deleted in main index, 6: deleted in delta index
    add_column :mini_blogs, :index_state, :integer, :default => 0
  end

  def self.down
    remove_column :mini_blogs, :index_state
  end
end
