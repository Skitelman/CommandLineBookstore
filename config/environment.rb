require "bundler/setup"
Bundler.require(:default, :development)
$: << "."

require "./app/models/memory_module"
Dir["app/models/*.rb"].each {|f| require f}
Dir["app/services/*.rb"].each {|f| require f}
Dir["app/formatters/*.rb"].each {|f| require f}
