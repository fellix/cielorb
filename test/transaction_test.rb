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
          response = transaction.make
          
          assert response.error.nil?
          
          assert "10069930690C6BA3A001", response.tid
          assert_equal "https://qasecommerce.cielo.com.br/web/index.cbmp?id=0197cb0d75c07073bd01b5bd9a452cb8", response.authentication_url
          assert_equal "0", response.status
          
          assert_equal "178148599", response.order_data.number
          assert_equal "1000", response.order_data.amount
          
          assert_equal "visa", response.payment_method.vendor
          assert_equal "A", response.payment_method.product
          assert_equal "1", response.payment_method.installments
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
          response = transaction.make
          
          assert !response.error.nil?
          assert_equal "002", response.error.code
          
          assert response.tid.nil?
          assert response.order_data.nil?
          assert response.payment_method.nil?
        end
      end
    end
  end
end