module Cielo
  class Transaction
    attr_reader :request

    def initialize(spec)
      @spec = spec
      @request = Request::Transaction.new(@spec)
      
      yield @request if block_given?
    end
    
    def create
      raise AlreadyPerformed.new("transaction already created") if @response
      
      response = Request.perform(@spec, @request)
      @response = Response::Transaction.new response[:transacao] || response
      
      success?
    end
    
    def create!
      unless create
        raise Failed.new(error.to_s)
      end
      
      success?
    end
    
    def success?
      raise NotCreated.new("transaction is not created yet") unless @response
      
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
    
    class AlreadyPerformed < StandardError; end
    class NotCreated < StandardError; end
    class Failed < StandardError; end
  end
end