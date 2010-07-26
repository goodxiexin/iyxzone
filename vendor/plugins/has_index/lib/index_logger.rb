class IndexLogger

  # 由于需要打开文件，所以用singleton设计模式，免除锁问题
  include Singleton

  def log msg
    @file.write "[#{time}]: #{msg}\n"
  end

  def close
    @file.close
  end
  
  def initialize
    @file = File.open("#{RAILS_ROOT}/log/index.log", "a")
  end

private

  def time
    Time.now.strftime("%Y-%m-%d %H:%M")
  end

end
