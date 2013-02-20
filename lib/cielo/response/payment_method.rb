module Cielo
  class Response::PaymentMethod < Response::Base
    attr_accessor :vendor, :product, :installments
    
    alias :bandeira= :vendor=
    alias :produto= :product=
    alias :parcelas= :installments=
  end
end