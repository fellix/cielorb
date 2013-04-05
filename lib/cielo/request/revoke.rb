require 'securerandom'
require 'builder'

module Cielo
  class Request::Revoke
    def initialize(spec)
      @spec = spec
      @builder = Builder::XmlMarkup.new :encoding => 'utf-8'
      @builder.instruct!
    end
    
    def define
      raise 'no block given' unless block_given?
      
      yield self
    end
    
    def tid(tid)
      @tid = tid
    end
    
    def amount(amount)
      @amount = amount
    end
    
    def to_xml
      clear_builder_buffer
      
      @builder.tag!("requisicao-cancelamento", id: SecureRandom.uuid, versao: "1.2.0") do |xml|
        xml.tid @tid
        
        xml.tag!("dados-ec") do |data|
          data.numero @spec.number
          data.chave @spec.token
        end
        
        xml.valor(@amount) if @amount
      end
    end
    
    private
    
    def clear_builder_buffer
      @builder = Builder::XmlMarkup.new :encoding => 'utf-8'
      @builder.instruct!
    end
  end
end