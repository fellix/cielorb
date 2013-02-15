require 'test_helpers'

class OrderDataTest < Minitest::Unit::TestCase
  def test_to_xml_conversion
    Time.stub :now, Time.at(0) do
      order_data = Cielo::Request::OrderData.new do |data|
        data.number "178148599"
        data.amount 1000
        data.currency 986
        data.time Time.now
        data.description "[origem:10.50.54.156]"
        data.language "PT"
      end
    
      assert_equal xml, order_data.to_xml
    end
  end
  
  def test_to_xml_with_defaults
    Time.stub :now, Time.at(0) do
      order_data = Cielo::Request::OrderData.new do |data|
        data.number "178148599"
        data.amount 1000
        data.description "[origem:10.50.54.156]"
      end
    
      assert_equal xml, order_data.to_xml
    end
  end
  
  def xml
    "<dados-pedido><numero>178148599</numero><valor>1000</valor><moeda>986</moeda><data-hora>1969-12-31 21:00:00 -0300</data-hora><descricao>[origem:10.50.54.156]</descricao><idioma>PT</idioma><soft-descriptor></soft-descriptor></dados-pedido>"
  end
end