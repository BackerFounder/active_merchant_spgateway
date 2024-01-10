# frozen_string_literal: true

require 'test_helper'

class SpgatewayTradeInfoTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup; end

  def test_trade_info_default_fields
    trade_info = Spgateway::TradeInfo.new

    assert_equal 'String', trade_info.fields['RespondType']
  end

  def test_trade_info_fields # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    trade_info = Spgateway::TradeInfo.new
    trade_info.merchant_id 'MS36595603'
    trade_info.time_stamp Time.at(1_701_683_903)
    trade_info.merchant_order_no '20140901001'
    trade_info.amt '100'
    trade_info.item_desc 'Test'
    trade_info.p3d true
    trade_info.version '2.0'

    assert_equal 'MS36595603', trade_info.fields['MerchantID']
    assert_equal 'String', trade_info.fields['RespondType']
    assert_equal 1_701_683_903, trade_info.fields['TimeStamp']
    assert_equal '2.0', trade_info.fields['Version']
    assert_equal '20140901001', trade_info.fields['MerchantOrderNo']
    assert_equal '100', trade_info.fields['Amt']
    assert_equal 'Test', trade_info.fields['ItemDesc']
    assert_equal '1', trade_info.fields['P3D']
  end

  def test_encoded_data
    trade_info = Spgateway::TradeInfo.new
    trade_info.merchant_id 'MS36595603'
    trade_info.version '2.0'
    trade_info.time_stamp Time.at(1_701_683_903)

    assert_equal 'MerchantID=MS36595603&RespondType=String&TimeStamp=1701683903&Version=2.0', trade_info.encoded_data
  end
end
