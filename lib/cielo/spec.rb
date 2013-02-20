module Cielo
  class Spec
    attr_accessor :token, :number, :endpoint
    
    def initialize(attributes = {})
      attributes.each do |attribute, value|
        __send__ "#{attribute}=", value
      end
    end
  end
end