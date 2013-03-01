module Cielo
  class Response::Transaction < Response::Base
    attr_accessor :tid, :pan, :status,
      :authentication_url
    
    alias :url_autenticacao= :authentication_url=
    
    attr_reader :order_data, :payment_method, :error
    
    def initialize(xml, attributes)
      @xml = xml
      
      super attributes
    end
    
    def order_data=(data)
      @order_data = Response::OrderData.new(data)
    end
    alias :dados_pedido= :order_data=
    
    def payment_method=(data)
      @payment_method = Response::PaymentMethod.new(data)
    end
    alias :forma_pagamento= :payment_method=
    
    def error=(data)
      @error = Response::Error.new(data)
    end
    alias :erro= :error=
    
    def xml
      @xml
    end
  end
end