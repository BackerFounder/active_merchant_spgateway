# frozen_string_literal: true

require 'digest'
require "#{File.dirname(__FILE__)}/spgateway/helper.rb"
require "#{File.dirname(__FILE__)}/spgateway/notification.rb"
require "#{File.dirname(__FILE__)}/spgateway/trade_info.rb"
require "#{File.dirname(__FILE__)}/spgateway/checksum"
require "#{File.dirname(__FILE__)}/spgateway/encrypt_data"

module OffsitePayments
  module Integrations
    module Spgateway # :nodoc:
      RESPOND_TYPE = 'String'

      CONFIG = %w[
        MerchantID
      ].freeze

      SERVICE_URL = {
        production: 'https://core.newebpay.com/MPG/mpg_gateway',
        development: 'https://ccore.newebpay.com/MPG/mpg_gateway'
      }.freeze

      mattr_accessor :hash_key
      mattr_accessor :hash_iv
      mattr_accessor :debug

      CONFIG.each do |field|
        mattr_accessor field.underscore.to_sym
      end

      def self.service_url=(service_url)
        @service_url = service_url
      end

      def self.service_url
        return @service_url if @service_url

        mode = ActiveMerchant::Billing::Base.mode
        SERVICE_URL[mode] || SERVICE_URL[:development]
      end

      def self.notification(post)
        Notification.new(post)
      end

      def self.setup
        yield(self)
      end
    end
  end
end
