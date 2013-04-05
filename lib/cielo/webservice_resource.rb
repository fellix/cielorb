module Cielo
  module WebserviceResource
    def success?
      raise Transaction::NotCreated.new("transaction is not created yet") unless @response
      
      @response.error.nil?
    end
    
    def failure?
      !success?
    end
    
    def method_missing(name, *args, &block)
      if @response && @response.respond_to?(name.to_sym) && !name.to_s.include?("=")
        @response.__send__ name, *args, &block
      else
        super
      end
    end
  end
end