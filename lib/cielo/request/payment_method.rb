module Cielo
  class Request::PaymentMethod
    def initialize(builder = Builder::XmlMarkup.new)
      @builder = builder
      yield self if block_given?
    end
    
    def vendor(value)
      @vendor = value
    end
    
    def product(value)
      @product = value
    end
    
    def installments(value)
      @installments = value
    end
    
    def to_xml(builder = @builder)
      builder.tag!("forma-pagamento") do |xml|
        xml.bandeira @vendor
        xml.produto @product
        xml.parcelas @installments
      end
    end
  end
end