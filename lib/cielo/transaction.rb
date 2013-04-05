module Cielo
  class Transaction
    include WebserviceResource
    
    attr_reader :request

    def initialize(spec)
      @spec = spec
      @request = Request::Transaction.new(@spec)
      
      yield @request if block_given?
    end
    
    def create
      raise AlreadyPerformed.new("transaction already created") if @response
      
      Cielo.notify_request(self, @request, @spec)
      response = Request.perform(@spec, @request)
      parsed = response.fetch :parsed

      @response = Response::Transaction.new(response.fetch(:xml), parsed[:transacao] || parsed)
      Cielo.notify_response(self, @response, @spec)
      
      success?
    end
    
    def create!
      unless create
        raise Failed.new(error.to_s)
      end
      
      success?
    end
    
    class AlreadyPerformed < StandardError; end
    class NotCreated < StandardError; end
    class Failed < StandardError; end
  end
end