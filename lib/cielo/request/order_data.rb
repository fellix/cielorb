module Cielo
  class Request::OrderData
    def initialize(builder = Builder::XmlMarkup.new)
      @builder = builder
      @currency = 986
      @time = Time.now
      @language = "PT"
      
      yield self if block_given?
    end
    
    def number(value)
      @number = value
    end
    
    def amount(value)
      @amount = value
    end
    
    def currency(value)
      @currency = value
    end
    
    def time(value)
      @time = value
    end
    
    def description(value)
      @description = value
    end
    
    def language(value)
      @language = value
    end
    
    def soft_descriptor(value)
      @soft_descriptor = value
    end
    
    def to_xml(builder = @builder)
      builder.tag!("dados-pedido") do |xml|
        xml.numero @number
        xml.valor @amount
        xml.moeda @currency
        xml.tag!("data-hora", @time)
        xml.descricao @description
        xml.idioma @language
        xml.tag!("soft-descriptor", @soft_descriptor)
      end
    end
  end
end