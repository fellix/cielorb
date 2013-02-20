module Cielo
  class Response::Error
    attr_reader :code, :message
    
    def initialize(attributes)
      @code = attributes[:codigo]
      @message = attributes[:mensagem]
    end
    
    def to_s
      "ERROR #{code} - #{message}"
    end
  end
end