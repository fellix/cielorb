require 'test_helpers'

class PaymentMethodTest < Minitest::Unit::TestCase
  def test_to_xml
    payment_method = Cielo::Request::PaymentMethod.new do |data|
      data.vendor "visa"
      data.product "A"
      data.installments 1
    end
    
    assert_equal xml, payment_method.to_xml
  end
  
  def xml
    "<forma-pagamento><bandeira>visa</bandeira><produto>A</produto><parcelas>1</parcelas></forma-pagamento>"
  end
end