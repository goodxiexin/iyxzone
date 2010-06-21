ActiveSupport::TestCase.class_eval do

  def assert_more expression, message=nil, &block
    b = block.send(:binding)
    exps = Array.wrap(expression)
    before = exps.map {|e| eval(e, b)}

    yield

    exps.each_with_index do |e, i|
      error = "#{e.inspect} didn't increase"
      error = "#{message}.\n#{error}" if message
      assert before[i] < eval(e, b), error
    end
  end

  def assert_less expression, message=nil, &block
    b = block.send(:binding)
    exps = Array.wrap(expression)
    before = exps.map {|e| eval(e, b)}

    yield

    exps.each_with_index do |e, i|
      error = "#{e.inspect} didn't increase"
      error = "#{message}.\n#{error}" if message
      assert before[i] > eval(e, b), error
    end
  end

end

