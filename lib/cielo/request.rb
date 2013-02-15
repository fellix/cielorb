module Cielo
  class Request
    autoload :PayerData, "cielo/request/payer_data"
    autoload :OrderData, "cielo/request/order_data"
    autoload :PaymentMethod, "cielo/request/payment_method"
    autoload :Transaction, "cielo/request/transaction"
  end
end