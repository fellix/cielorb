require 'builder'

module Cielo
  class Request::PayerData
    def initialize(builder = Builder::XmlMarkup.new)
      @builder = builder
      yield self if block_given?
    end
    
    def number(value)
      @number = value
    end
    
    def expiration(value)
      @expiration = value
    end
    
    def indicator(value)
      @indicator = value
    end
    
    def security_code(value)
      @security_code = value
    end
    
    def to_xml(builder = @builder)
      builder.tag!("dados-portador") do |xml|
        xml.numero @number
        xml.validade @expiration
        xml.indicador @indicator
        xml.tag!("codigo-seguranca", @security_code)
      end
    end
  end
end