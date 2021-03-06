#encoding: utf-8
require 'test_helpers'

class RevokeTest < Minitest::Unit::TestCase
  def test_quering_a_transaction
    spec = Cielo::Spec.new(
      number: 1006993069,
      token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
      endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
    )
    
    revoke = Cielo::Revoke.new(spec) do |request|
      request.tid "10069930690C69EBA001"
    end
    
    VCR.use_cassette("cielo_transaction_revoke") do
      assert revoke.perform
      
      assert "10069930690C69EBA001", revoke.tid
      assert "178148599", revoke.order_data.number
    end
  end
end