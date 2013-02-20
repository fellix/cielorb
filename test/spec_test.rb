require 'test_helpers'

class SpecTest < Minitest::Unit::TestCase
  def test_transaction_shortcut
    spec = Cielo::Spec.new(
      number: 1006993069,
      token: "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3",
      endpoint: "https://qasecommerce.cielo.com.br/servicos/ecommwsec.do"
    )
    
    transaction = spec.transaction do |request|
      request.bin "455187"
    end
    
    assert transaction.is_a?(Cielo::Transaction)
    assert_match "<bin>455187</bin>", transaction.request.to_xml
  end
end