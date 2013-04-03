#encoding: utf-8
require 'test_helpers'

class QueryRequestTest < Minitest::Unit::TestCase
  def test_generate_xml
    spec = Cielo::Spec.new(token: "25fbb997438630f30b112d033ce2e62", number: "1006993069")
    req = Cielo::Request::Query.new(spec)
    req.define do |request|
      request.tid "10069930690C69EBA001"
    end
    
    SecureRandom.stub :uuid, "3e80042f-fffd-42e5-b875-af85fc77a75a" do
      assert_equal request_xml_sample, req.to_xml
    end
  end
  
  def request_xml_sample
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><requisicao-consulta id=\"3e80042f-fffd-42e5-b875-af85fc77a75a\" versao=\"1.2.0\"><tid>10069930690C69EBA001</tid><dados-ec><numero>1006993069</numero><chave>25fbb997438630f30b112d033ce2e62</chave></dados-ec></requisicao-consulta>"
  end
end