# frozen_string_literal: true

require 'test_helper'

class SpgatewayNotificationTestWithTradeInfo < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
    OffsitePayments::Integrations::Spgateway.hash_key = 'Fs5cX1TGqYM2PpdbE14a9H83YQSQF5jn'
    OffsitePayments::Integrations::Spgateway.hash_iv = 'C6AcmfqJILwgnhIP'
    @spgateway = Spgateway::Notification.new(http_raw_data)
  end

  def test_complete?
    assert @spgateway.complete?
  end

  def test_trade_info # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    assert @spgateway.trade_info.is_a?(Spgateway::Notification::TradeInfo)
    assert_equal 'SUCCESS', @spgateway.trade_info.status
    assert_equal '授權成功', @spgateway.trade_info.message
    assert_equal 'MS127874575', @spgateway.trade_info.merchant_id
    assert_equal '30', @spgateway.trade_info.amt
    assert_equal '23092714215835071', @spgateway.trade_info.trade_no
    assert_equal 'Vanespl_ec_1695795668', @spgateway.trade_info.merchant_order_no
    assert_equal 'String', @spgateway.trade_info.respond_type
    assert_equal '123.51.237.115', @spgateway.trade_info.ip
    assert_equal 'HNCB', @spgateway.trade_info.escrow_bank
    assert_equal 'CREDIT', @spgateway.trade_info.payment_type
    assert_equal '00', @spgateway.trade_info.respond_code
    assert_equal '115468', @spgateway.trade_info.auth
    assert_equal '400022', @spgateway.trade_info.card6_no
    assert_equal '1111', @spgateway.trade_info.card4_no
    assert_equal 'KGI', @spgateway.trade_info.auth_bank
    assert_equal '0', @spgateway.trade_info.token_use_status
    assert_equal '0', @spgateway.trade_info.inst_first
    assert_equal '0', @spgateway.trade_info.inst_each
    assert_equal '0', @spgateway.trade_info.inst
    assert_equal '', @spgateway.trade_info.eci
    assert_equal '2023-09-27 14:21:59', @spgateway.trade_info.pay_time
    assert_equal 'CREDIT', @spgateway.trade_info.payment_method
    assert_equal 'Status=SUCCESS&Message=%E6%8E%88%E6%AC%8A%E6%88%90%E5%8A%9F&MerchantID=MS127874575&Amt=30&TradeNo=23092714215835071&MerchantOrderNo=Vanespl_ec_1695795668&RespondType=String&IP=123.51.237.115&EscrowBank=HNCB&PaymentType=CREDIT&RespondCode=00&Auth=115468&Card6No=400022&Card4No=1111&Exp=2609&AuthBank=KGI&TokenUseStatus=0&InstFirst=0&InstEach=0&Inst=0&ECI=&PayTime=2023-09-27+14%3A21%3A59&PaymentMethod=CREDIT', @spgateway.trade_info.encode_www_form # rubocop:disable Layout/LineLength
  end

  def test_checksum_ok?
    assert @spgateway.checksum_ok?
  end

  private

  def http_raw_data
    # 來自藍新文件上的範例
    'Status=SUCCESS&MerchantID=MS127874575&Version=2.0&TradeInfo=ee11d1501e6dc8433c75988258f2343d11f4d0a423be672e8e02aaf373c53c2363aeffdb4992579693277359b3e449ebe644d2075fdfbc10150b1c40e7d24cb215febefdb85b16a5cde449f6b06c58a5510d31e8d34c95284d459ae4b52afc1509c2800976a5c0b99ef24cfd28a2dfc8004215a0c98a1d3c77707773c2f2132f9a9a4ce3475cb888c2ad372485971876f8e2fec0589927544c3463d30c785c2d3bd947c06c8c33cf43e131f57939e1f7e3b3d8c3f08a84f34ef1a67a08efe177f1e663ecc6bedc7f82640a1ced807b548633cfa72d060864271ec79854ee2f5a170aa902000e7c61d1269165de330fce7d10663d1668c711571776365bfdcd7ddc915dcb90d31a9f27af9b79a443ca8302e508b0dbaac817d44cfc44247ae613075dde4ac960f1bdff4173b915e4344bc4567bd32e86be7d796e6d9b9cf20476e4996e98ccc315f1ed03a34139f936797d971f2a3f90bc18f8a155a290bcbcf04f4277171c305bf554f5cba243154b30082748a81f2e5aa432ef9950cc9668cd4330ef7c37537a6dcb5e6ef01b4eca9705e4b097cf6913ee96e81d0389e5f775&TradeSha=C80876AEBAC0036268C0E240E5BFF69C0470DE9606EEE083C5C8DD64FDB3347A' # rubocop:disable Layout/LineLength
  end
end
