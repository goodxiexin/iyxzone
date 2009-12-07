class << ActiveRecord::Base

	def find_or_create attrs
    record = find(:first, :conditions => attrs)
    record = create(attrs) if record.nil?
    record
  end

end
