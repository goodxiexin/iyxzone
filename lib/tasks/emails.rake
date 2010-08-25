namespace :emails do

  desc "检查domain的合法性"
  task :validate_domains => :environment do
    now = Time.now
    EmailDomain.match(["validated_at < ?", 7.days.ago]).all.each do |d|
      if EmailDomain.validate_dns d.domain
        d.update_attributes :validated_at => now
      else
        d.destroy
      end
    end
  end

end
