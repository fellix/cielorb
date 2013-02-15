ENV['RACK_ENV'] ||= 'test'
require 'test/unit'
require 'minitest/spec'
require 'minitest/mock'
require 'turn'

### SUPPORT ###
Dir["test/support/*.rb"].each do |file|
  require File.expand_path(file)
end

require 'cielo'