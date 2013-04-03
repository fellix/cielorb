require 'uri'
require 'httpi'
require 'nokogiri'
require 'nori'

module Cielo
  class Request
    autoload :PayerData, "cielo/request/payer_data"
    autoload :OrderData, "cielo/request/order_data"
    autoload :PaymentMethod, "cielo/request/payment_method"
    autoload :Transaction, "cielo/request/transaction"
    autoload :Query, "cielo/request/query"
    
    def self.perform(spec, source)
      req = new(spec)
      req.perform(source)
    end
    
    class InvalidEndpoint < StandardError; end
    
    def initialize(spec)
      raise InvalidEndpoint.new("endpoint is required") unless spec.endpoint
      unless spec.endpoint =~ URI::regexp
        raise InvalidEndpoint.new("endpoint is invalid, must be an URL")
      end
      
      @spec = spec
    end
    
    def perform(source)
      request = build_request(source)
      
      response = post(request)
      xml = response.body
      
      {
        parsed: xml_parser.parse(xml),
        xml: xml
      }
    end
    
    private
    
    def build_request(source)
      request = HTTPI::Request.new(@spec.endpoint)
      request.body = { mensagem: source.to_xml }
      request.auth.ssl.verify_mode = :none
      request.auth.ssl.ssl_version = :SSLv3  
      
      request
    end
    
    def post(request)
      HTTPI.post(request)
    end
    
    def xml_parser
      @xml_parser ||= Nori.new(convert_tags_to: ->(tag){ tag.snakecase.to_sym })
    end
  end
end