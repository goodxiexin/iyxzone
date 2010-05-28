#
# 写些自己的validation
module CustomValidations

  def validates_bytes_of *attrs
    options = attrs.extract_options!.merge({:tokenizer => lambda {|val| val}})
    validates_size_of attrs, options
  end

end

ActiveRecord::Base.extend(CustomValidations)

