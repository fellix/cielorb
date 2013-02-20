module Cielo
  class Response
    autoload :Base, "cielo/response/base"
    autoload :Transaction, "cielo/response/transaction"
    autoload :OrderData, "cielo/response/order_data"
    autoload :PaymentMethod, "cielo/response/payment_method"
    autoload :Error, "cielo/response/error"
  end
end