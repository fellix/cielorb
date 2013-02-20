module Cielo
  class Transaction
    def initialize(spec)
      @spec = spec
      @request = Request::Transaction.new(@spec)
      
      yield @request if block_given?
    end
    
    def make
      response = Request.perform(@spec, @request)
      Response::Transaction.new response[:transacao] || response
    end
  end
end