#encoding: utf-8
require 'test_helpers'

class TransactionTest < Minitest::Unit::TestCase
  def test_building_and_making_a_transaction
    Time.stub :now, Time.at(0) do
      spec = Cielo::Spec.new(
        number: 1006993069,
        token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
        endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
      )
      
      transaction = Cielo::Transaction.new(spec) do |request|
        request.payer_data do |data|
          data.number "4012001038443335"
          data.expiration "201508"
          data.indicator "1"
          data.security_code "973"
        end
        
        request.order_data do |data|
          data.number "178148599"
          data.amount 1000
          data.currency 986
          data.time Time.now
          data.description "[origem:10.50.54.156]"
          data.language "PT"
        end
    
        request.payment_method do |data|
          data.vendor "visa"
          data.product "A"
          data.installments 1
        end
      
        request.return_url "http://localhost/lojaexemplo/retorno.jsp"
        request.authorize 1
        request.capture false
        request.observation "Informacoes extras"
        request.bin "455187"
      end
      
      SecureRandom.stub :uuid, "3e80042f-fffd-42e5-b875-af85fc77a75a" do
        VCR.use_cassette("cielo_transaction_make") do
          assert transaction.create
          
          assert transaction.success?
          assert !transaction.failure?
          
          assert "10069930690C6BA3A001", transaction.tid
          assert_equal "https://qasecommerce.cielo.com.br/web/index.cbmp?id=0197cb0d75c07073bd01b5bd9a452cb8", transaction.authentication_url
          assert_equal "0", transaction.status
          
          assert_equal "178148599", transaction.order_data.number
          assert_equal "1000", transaction.order_data.amount
          
          assert_equal "visa", transaction.payment_method.vendor
          assert_equal "A", transaction.payment_method.product
          assert_equal "1", transaction.payment_method.installments
        end
      end
    end
  end
  
  def test_make_with_cielo_error
    Time.stub :now, Time.at(0) do
      spec = Cielo::Spec.new(
        number: 1006993069,
        token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
        endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
      )
      
      transaction = Cielo::Transaction.new(spec) do |request|
        request.payer_data do |data|
          data.number "4012001038443335"
          data.expiration "201508"
          data.indicator "1"
          data.security_code "973"
        end
        
        request.order_data do |data|
          data.number "178148599"
          data.amount 1000
          data.currency 986
          data.time Time.now
          data.description "[origem:10.50.54.156]"
          data.language "PT"
        end
    
        request.payment_method do |data|
          data.vendor "visa"
          data.product "A"
          data.installments 1
        end
      
        request.return_url "http://localhost/lojaexemplo/retorno.jsp"
        request.authorize 1
        request.capture false
        request.observation "Informacoes extras"
        request.bin "455187"
      end
      
      SecureRandom.stub :uuid, "3e80042f-fffd-42e5-b875-af85fc77a75a" do
        VCR.use_cassette("cielo_transaction_with_error") do
          assert !transaction.create
          
          assert !transaction.success?
          assert transaction.failure?
          assert_equal "002", transaction.error.code
          
          assert transaction.tid.nil?
          assert transaction.order_data.nil?
          assert transaction.payment_method.nil?
        end
      end
    end
  end
  
  def test_do_not_allow_to_create_same_transaction_twice
    spec = Cielo::ShopTestSpec.new
    
    transaction = Cielo::Transaction.new(spec)
    transaction.instance_variable_set("@response", "a")
    
    assert_raises(Cielo::Transaction::AlreadyPerformed) { transaction.create }
  end
  
  def test_raises_exception_calling_success_when_the_transaction_has_not_created_yeat
    spec = Cielo::ShopTestSpec.new
    
    transaction = Cielo::Transaction.new(spec)
    
    assert_raises(Cielo::Transaction::NotCreated) { transaction.success? }
  end
  
  def test_raises_exception_calling_failure_when_the_transaction_has_not_created_yeat
    spec = Cielo::ShopTestSpec.new
    
    transaction = Cielo::Transaction.new(spec)
    
    assert_raises(Cielo::Transaction::NotCreated) { transaction.failure? }
  end
  
  def test_raises_exception_when_triyng_to_access_a_response_setter
    spec = Cielo::ShopTestSpec.new
    
    transaction = Cielo::Transaction.new(spec)
    transaction.instance_variable_set("@response", Cielo::Response::Transaction.new("", {}))
    
    assert_raises(NoMethodError) { transaction.tid = "123" }
  end
  
  def test_raises_exception_when_the_transaction_has_error
    Time.stub :now, Time.at(0) do
      spec = Cielo::ShopTestSpec.new
      
      transaction = Cielo::Transaction.new(spec)
      
      SecureRandom.stub :uuid, "3e80042f-fffd-42e5-b875-af85fc77a75a" do
        VCR.use_cassette("cielo_transaction_with_error") do
          exp = assert_raises(Cielo::Transaction::Failed) { transaction.create! }
          assert_equal "ERROR 002 - Credenciais inválidas.", exp.message
        end
      end
    end
  end
  
  class MyObserver
    attr_reader :request_count, :response_count
    def initialize
      @request_count = 0
      @response_count = 0
    end
      
    def notify_request(*args)
      @request_count += 1
    end
      
    def notify_response(*args)
      @response_count += 1
    end
  end
  
  def test_notify_observers
    VCR.use_cassette("cielo_transaction_make") do
      observer = MyObserver.new
      
      Cielo.observers << observer
      spec = Cielo::ShopTestSpec.new
      
      transaction = Cielo::Transaction.new(spec)
      
      assert_equal 0, observer.request_count
      assert_equal 0, observer.response_count
      
      transaction.create
      
      assert_equal 1, observer.request_count
      assert_equal 1, observer.response_count
    end
  end
end