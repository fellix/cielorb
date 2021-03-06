require 'securerandom'
require 'builder'

module Cielo
  class Request::Transaction
    def initialize(spec)
      @spec = spec
      @builder = Builder::XmlMarkup.new :encoding => 'utf-8'
      @builder.instruct!
    end
    
    def define
      raise 'no block given' unless block_given?
      
      yield self
    end
    
    def payer_data
      @payer_data = Request::PayerData.new(@builder)
      
      yield @payer_data
    end
    
    def order_data
      @order_data = Request::OrderData.new(@builder)
      
      yield @order_data
    end
    
    def payment_method
      @payment_method = Request::PaymentMethod.new(@builder)
      
      yield @payment_method
    end
    
    def return_url(value)
      @return_url = value
    end
    
    def authorize(value)
      @authorize = value
    end
    
    def capture(value)
      @capture = value
    end
    
    def observation(value)
      @observation = value
    end
    
    def bin(value)
      @bin = value
    end
    
    def to_xml
      clear_builder_buffer
      @builder.tag!("requisicao-transacao", id: SecureRandom.uuid, versao: "1.2.0") do |xml|
        xml.tag!("dados-ec") do |data|
          data.numero @spec.number
          data.chave @spec.token
        end
        
        @payer_data.to_xml(xml) if @payer_data
        @order_data.to_xml(xml) if @order_data
        @payment_method.to_xml(xml) if @payment_method
        
        xml.tag!("url-retorno", @return_url)
        xml.autorizar @authorize
        xml.capturar @capture
        xml.tag!("campo-livre", @observation) if @observation
        xml.bin @bin if @bin
      end
    end
    
    private
    
    def clear_builder_buffer
      @builder = Builder::XmlMarkup.new :encoding => 'utf-8'
      @builder.instruct!
    end
  end
end