ENV['RACK_ENV'] ||= 'test'
require 'test/unit'
require 'minitest/spec'
require 'minitest/mock'
require 'turn'
require 'vcr'
require 'webmock/test_unit'

### SUPPORT ###
Dir["test/support/*.rb"].each do |file|
  require File.expand_path(file)
end

require 'cielo'
require 'httpi'

HTTPI.log = false