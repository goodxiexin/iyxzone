namespace :utils do

  desc :convert => :environment do
    template = File.read("public/stylesheet/home.css.erb" )
    page = ERB.new(template).result(binding)
  end

end
