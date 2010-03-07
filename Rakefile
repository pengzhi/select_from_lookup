require 'rubygems'
require 'rake'
require 'echoe'
 
Echoe.new('select_from_lookup', '0.1.0') do |p|
  p.description = "Generate drop down box for lookup values using belongs_to"
  p.url = "http://github.com/pengzhi/Select-From-Lookup"
  p.author = "Pengzhi Quah"
  p.email = "pengzhiq@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end
 
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }