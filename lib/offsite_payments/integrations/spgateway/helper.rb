# frozen_string_literal: true

require 'digest'

module OffsitePayments
  module Integrations
    module Spgateway
      class Helper < OffsitePayments::Helper # :nodoc:
        FIELDS = %w[
          MerchantID
          Version
        ].freeze

        FIELDS.each do |field|
          mapping field.underscore.to_sym, field
        end

        def initialize(order, account, options = {})
          super
          OffsitePayments::Integrations::Spgateway::CONFIG.each do |field|
            add_field field, OffsitePayments::Integrations::Spgateway.send(field.underscore.to_sym)
          end
        end

        def trade_info(
          hash_key = OffsitePayments::Integrations::Spgateway.hash_key,
          hash_iv = OffsitePayments::Integrations::Spgateway.hash_iv
        )
          trade_info = Spgateway::TradeInfo.new
          yield trade_info

          encrypted_data = Spgateway::EncryptData.encrypt(trade_info.encoded_data, hash_key, hash_iv)
          checksum = Spgateway::Checksum.generate(encrypted_data, hash_key, hash_iv)
          add_field 'TradeInfo', encrypted_data
          add_field 'TradeSha', checksum
        end
      end
    end
  end
end
