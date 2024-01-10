require 'test_helper'

class SpgatewayModuleTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def test_notification_method
    assert_instance_of Spgateway::Notification, Spgateway.notification('name=cody')
  end

  def test_production_service_url
    ActiveMerchant::Billing::Base.mode = :production
    assert_equal Spgateway.service_url, 'https://core.newebpay.com/MPG/mpg_gateway'
  end

  def test_development_service_url
    ActiveMerchant::Billing::Base.mode = :development
    assert_equal Spgateway.service_url, 'https://ccore.newebpay.com/MPG/mpg_gateway'
  end

  def test_staging_service_url
    ActiveMerchant::Billing::Base.mode = :staging
    assert_equal Spgateway.service_url, 'https://ccore.newebpay.com/MPG/mpg_gateway'
  end

  def test_service_url
    ActiveMerchant::Billing::Base.mode = :test
    assert_equal Spgateway.service_url, 'https://ccore.newebpay.com/MPG/mpg_gateway'
  end
end
