require 'test_helpers'

class PayerDataTest < Minitest::Unit::TestCase
  def test_to_xml_conversion
    payer_data = Cielo::Request::PayerData.new do |data|
      data.number "4012001038443335"
      data.expiration "201508"
      data.indicator "1"
      data.security_code "973"
    end
    
    assert_equal xml, payer_data.to_xml
  end
  
  def xml
    "<dados-portador><numero>4012001038443335</numero><validade>201508</validade><indicador>1</indicador><codigo-seguranca>973</codigo-seguranca></dados-portador>"
  end
end