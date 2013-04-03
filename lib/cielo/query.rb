module Cielo
  class Query
    attr_reader :request

    def initialize(spec)
      @spec = spec
      @request = Request::Query.new(@spec)
      
      yield @request if block_given?
    end
    
    def perform
      Cielo.notify_request(self, @request, @spec)
      response = Request.perform(@spec, @request)
      parsed = response.fetch :parsed

      @response = Response::Transaction.new(response.fetch(:xml), parsed[:transacao] || parsed)
      Cielo.notify_response(self, @response, @spec)
      
      @response
    end
  end
end