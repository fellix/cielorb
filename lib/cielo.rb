require "cielo/version"
require 'securerandom'
require 'builder'
require 'nokogiri'
require 'nori'

module Cielo
  autoload :Spec, "cielo/spec"
  autoload :Transaction, "cielo/transaction"
  autoload :Request, "cielo/request"
  autoload :Response, "cielo/response"
end
