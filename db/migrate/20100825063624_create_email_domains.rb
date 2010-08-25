class CreateEmailDomains < ActiveRecord::Migration
  def self.up
    create_table :email_domains do |t|
      t.string :domain
      t.datetime :validated_at
    end
  end

  def self.down
    drop_table :email_domains
  end
end
