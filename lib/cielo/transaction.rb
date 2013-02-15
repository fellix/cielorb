module Cielo
  class Transaction
    def initialize(spec)
      @spec = spec
      @request = Request::Transaction.new
      
      yield @request if block_given?
    end
  end
end