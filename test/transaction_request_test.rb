#encoding: utf-8
require 'test_helpers'

class TransactionRequestTest < Minitest::Unit::TestCase
  def test_generate_request_xml
    Time.stub :now, Time.at(0) do
      spec = Cielo::Spec.new(token: "25fbb997438630f30b112d033ce2e62", number: "1006993069")
      req = Cielo::Request::Transaction.new(spec)
      req.define do |request|
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
        assert_equal request_xml_sample, req.to_xml
      end
    end
  end
  
  def request_xml_sample
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><requisicao-transacao id=\"3e80042f-fffd-42e5-b875-af85fc77a75a\" versao=\"1.2.0\"><dados-ec><numero>1006993069</numero><chave>25fbb997438630f30b112d033ce2e62</chave></dados-ec><dados-portador><numero>4012001038443335</numero><validade>201508</validade><indicador>1</indicador><codigo-seguranca>973</codigo-seguranca></dados-portador><dados-pedido><numero>178148599</numero><valor>1000</valor><moeda>986</moeda><data-hora>1969-12-31T21:00:00</data-hora><descricao>[origem:10.50.54.156]</descricao><idioma>PT</idioma><soft-descriptor/></dados-pedido><forma-pagamento><bandeira>visa</bandeira><produto>A</produto><parcelas>1</parcelas></forma-pagamento><url-retorno>http://localhost/lojaexemplo/retorno.jsp</url-retorno><autorizar>1</autorizar><capturar>false</capturar><campo-livre>Informacoes extras</campo-livre><bin>455187</bin></requisicao-transacao>"
  end
end