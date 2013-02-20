module Cielo
  class Response::OrderData < Response::Base
    attr_accessor :number, :amount, :currency, :date_time, :description,
      :language
      
    alias :numero= :number=
    alias :valor= :amount=
    alias :moeda= :currency=
    alias :data_hora= :date_time=
    alias :descricao= :description=
    alias :idioma= :language=
  end
end