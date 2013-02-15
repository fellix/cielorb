module Cielo
  class Spec
    attr_accessor :token, :number
    
    def initialize(attributes = {})
      attributes.each do |attribute, value|
        __send__ "#{attribute}=", value
      end
    end
  end
end