class MiniBlogFactory

  def self.create opts={}
    if opts[:poster].nil?
      opts[:poster] = UserFactory.create
    end

    Factory.create :mini_blog, opts
  end

end
