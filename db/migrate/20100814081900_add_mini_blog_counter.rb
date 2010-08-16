class AddMiniBlogCounter < ActiveRecord::Migration
  def self.up
    add_column :users, :mini_blogs_count, :integer, :default => 0
    MiniBlog.all(:select => "id, poster_id").group_by(&:poster_id).each do |poster_id, mbs|
      u = User.find poster_id
      u.mini_blogs_count = mbs.count
      u.save
      puts "save #{u.id}, #{u.mini_blogs_count}"
    end
  end

  def self.down
  end
end
