require "cielo/version"

module Cielo
  autoload :Spec, "cielo/spec"
  autoload :ShopTestSpec, "cielo/spec"
  autoload :CieloTestSpec, "cielo/spec"
  autoload :Transaction, "cielo/transaction"
  autoload :Query, "cielo/query"
  autoload :Request, "cielo/request"
  autoload :Response, "cielo/response"
  
  def self.observers
    @observers ||= []
  end
  
  def self.notify_request(object, request, spec)
    observers.each { |obs| obs.notify_request(object, request, spec) }
  end
  
  def self.notify_response(object, response, spec)
    observers.each { |obs| obs.notify_response(object, response, spec) }
  end
end