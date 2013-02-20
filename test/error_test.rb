#encoding: utf-8
require 'test_helpers'

class ErrorTest < Minitest::Unit::TestCase
  def test_parse_a_hash_to_build_the_error_object
    error = Cielo::Response::Error.new({:codigo => "002", :mensagem => "Credenciais inválidas"})
    
    assert_equal "002", error.code
    assert_equal "Credenciais inválidas", error.message
    assert_equal "ERROR 002 - Credenciais inválidas", error.to_s
  end
end