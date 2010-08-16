class AddDefaultProfileTags < ActiveRecord::Migration
  def self.up
    Tag::DEFAULT_MALE_TAGS.each do |tag|
      Tag.create :name => tag, :taggable_type => "Profile"
    end
    Tag::DEFAULT_FEMALE_TAGS.each do |tag|
      Tag.create :name => tag, :taggable_type => "Profile"
    end
  end

  def self.down
  end
end
