# frozen_string_literal: true

require 'test_helper'

class SpgatewayHelperWithMerchantHashTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup; end

  def test_trade_info # rubocop:disable Metrics/MethodLength
    @helper = Spgateway::Helper.new 'sdfasdfa', '123456'

    @helper.trade_info(
      'GADlNOKdHiTBjdgW6uAjngF9ItT6nCW4',
      'dzq1naf5t8HMmXIs'
    ) do |info|
      info.merchant_id 'MS127874575'
      info.version '2.0'
      info.merchant_order_no 'Vanespl_ec_1695795410'
      info.time_stamp Time.at(1_695_795_410)
      info.amt '30'
      info.item_desc 'test'
      info.notify_url 'https://webhook.site/d4db5ad1-2278-466a-9d66-78585c0dbadb'
    end

    assert_equal '730a780f5ddecf2c1cb09d06c05d58196e120f13505735bc0607fea374b5e51677fe63b6f5d477be9238bf04d61b27ebbd6b984a5132cfef4f5e657a8c58a1e202bf8486ea67ba7a366ace95a8dcb3b4938af861b4e2d6d0a387eac60dfb3cdaeec71e0ee452f2919406bd7a18255f50ee7e5df66d9cec108790cc35eb558318e5cfd6433042127bbf30ced91344754536477b44276dd1fd7c5652ea6a12b49a78aca997526c78428364904ca8442592a8bab91c82b109f9d619b4a0faead412dc67a630bb5ab90bf01a068f240dfdbc9978579d990661bde7d40e53a9904970', # rubocop:disable Layout/LineLength
                 @helper.fields['TradeInfo']
  end

  def test_trade_sha # rubocop:disable Metrics/MethodLength
    @helper = Spgateway::Helper.new 'sdfasdfa', '123456'

    @helper.trade_info(
      'GADlNOKdHiTBjdgW6uAjngF9ItT6nCW4',
      'dzq1naf5t8HMmXIs'
    ) do |info|
      info.merchant_id 'MS127874575'
      info.version '2.0'
      info.merchant_order_no 'Vanespl_ec_1695795410'
      info.time_stamp Time.at(1_695_795_410)
      info.amt '30'
      info.item_desc 'test'
      info.notify_url 'https://webhook.site/d4db5ad1-2278-466a-9d66-78585c0dbadb'
    end

    assert_equal '258DDAC50A0BDB4C2B2B007465D82CE6CE7108B2EF644375E91D90FB3502D2D1',
                 @helper.fields['TradeSha']
  end
end
