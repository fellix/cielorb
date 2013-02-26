module Cielo
  class Spec
    attr_accessor :token, :number, :endpoint
    
    def initialize(attributes = {})
      attributes.each do |attribute, value|
        __send__ "#{attribute}=", value
      end
    end

    def transaction(&block)
      Cielo::Transaction.new(self, &block)
    end
  end
  
  class ShopTestSpec < Spec
    def initialize
      super(
        number: 1006993069,
        token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
        endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
      )
    end
  end
  
  class CieloTestSpec < Spec
    def initialize
      super(
        number: 1001734898,
        token: "e84827130b9837473681c2787007da5914d6359947015a5cdb2b8843db0fa832",
        endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
      )
    end
  end
end