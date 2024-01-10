# frozen_string_literal: true

require 'test_helper'

class SpgatewayChecksumTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup; end

  def test_generate
    params = 'Amt=10&MerchantID=MS12345678&MerchantOrderNo=MyCompanyOrder_1638423361&TradeNo=21120214151152468'
    result = Spgateway::Checksum.generate(params, 'hash_key_foobar', 'hash_iv_foobar')
    assert_equal '1F4A7AA09F2454C76047EE58725F1AA59EBCCB2E835121E0EE21D5A16D9728A5', result
  end

  def test_generate_with_customized_key_format
    params = 'Amt=10&MerchantID=MS12345678&MerchantOrderNo=MyCompanyOrder_1638423361&TradeNo=21120214151152468'
    result = Spgateway::Checksum.generate(params, 'hash_key_foobar', 'hash_iv_foobar', prefixer_format: 'Key', suffixer_format: 'IV') # rubocop:disable Layout/LineLength
    assert_equal '65B88A07655F6374067A2321230117E23D69624E9A1BA076D2F6ACE5953DCD13', result
  end
end
