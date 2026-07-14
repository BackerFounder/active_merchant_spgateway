# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Spgateway
      class TradeInfo # :nodoc:
        attr_reader :fields

        TRADE_INFO_FIELDS = %w[
          Amt
          ANDROIDPAY
          APPLEPAY
          BankType
          BARCODE
          ClientBackURL
          CREDIT
          CREDITAE
          CREDITAGREEMENT
          CreditRed
          CUSTOM
          CustomerURL
          CVS
          CVSCOM
          Email
          EmailModify
          ESUNWALLET
          ExpireDate
          EZPALIPAY
          EZPAY
          EZPWECHAT
          FULA
          ImageUrl
          InstFlag
          ItemDesc
          LangType
          LgsType
          LINEPAY
          LoginType
          MerchantID
          MerchantOrderNo
          NotifyURL
          OrderComment
          ReturnURL
          SAMSUNGPAY
          TAIWANPAY
          TokenLife
          TokenTerm
          TradeLimit
          UNIONPAY
          VACC
          Version
          WEBATM
        ].freeze

        def initialize
          @fields = {}
          @fields['RespondType'] = OffsitePayments::Integrations::Spgateway::RESPOND_TYPE
        end

        TRADE_INFO_FIELDS.each do |field|
          define_method field.underscore.to_sym do |value|
            @fields[field.to_s] = value
          end
        end

        def encoded_data
          URI.encode_www_form @fields.sort
        end

        def p3d(enable_p3d = false) # rubocop:disable Style/OptionalBooleanParameter
          @fields['P3D'] = enable_p3d ? '1' : '0'
        end

        def time_stamp(date)
          @fields['TimeStamp'] = date.to_time.to_i
        end
      end
    end
  end
end
