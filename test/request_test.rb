require 'test_helpers'

class RequestTest < Minitest::Unit::TestCase
  def test_peform_a_request_using_a_spec_without_endpoint
    spec = Cielo::Spec.new
    
    assert_raises(Cielo::Request::InvalidEndpoint) { Cielo::Request.perform(spec, nil) }
  end
  
  def test_perform_a_request_using_an_invalid_endpoint
    spec = Cielo::Spec.new(endpoint: "xpto")
    
    assert_raises(Cielo::Request::InvalidEndpoint) { Cielo::Request.perform(spec, nil) }
  end
  
  def test_perform_a_request_to_cielo_services
    VCR.use_cassette("cielo_transaction_create") do
      spec = Cielo::Spec.new(
        number: 1006993069,
        token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
        endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
      )
      
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
      
      resp = Cielo::Request.perform(spec, req)
      assert_equal response_hash, resp[:parsed]
    end
  end
  
  def response_hash
    {
      :transacao => {
        :tid=>"10069930690C69EBA001",
        :pan=>"5UeSVNFr1L76SHYZclDdTlr3Ax2Z84mstUQoXbV9AE0=",
        :dados_pedido=> {
          :numero=>"178148599", :valor=>"1000", :moeda=>"986",
          :data_hora=> DateTime.parse("2013-02-19T18:37:37.160-03:00"),
          :descricao=>"[origem:10.50.54.156]", :idioma=>"PT"
        },
        :forma_pagamento=>{
          :bandeira=>"visa", :produto=>"A", :parcelas=>"1"
        },
        :status=>"0",
        :url_autenticacao=>"https://qasecommerce.cielo.com.br/web/index.cbmp?id=3a575e009dcf5b158fa930f38ee97453",
        :@xmlns=>"http://ecommerce.cbmp.com.br", :@versao=>"1.2.0",
        :@id=>"8ef30992-bee6-4c57-a786-71b803322ce0"
      }
    }
  end
end