module Cielo
  class Response::Base
    def initialize(attributes)
      attributes.each do |attribute, value|
        if respond_to?("#{attribute}=")
          __send__ "#{attribute}=", value
        end
      end
    end
  end
end