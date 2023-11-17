# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Spgateway
      class TradeInfo # :nodoc:
        attr_reader :fields

        TRADE_INFO_FIELDS = %w[
          MerchantID
          Version
          LangType
          MerchantOrderNo
          Amt
          ItemDesc
          TradeLimit
          ExpireDate
          ReturnURL
          NotifyURL
          CustomerURL
          ClientBackURL
          Email
          EmailModify
          LoginType
          OrderComment
          CREDIT
          CreditRed
          CREDITAE
          ANDROIDPAY
          SAMSUNGPAY
          ESUNWALLET
          TAIWANPAY
          LINEPAY
          ImageUrl
          InstFlag
          UNIONPAY
          FULA
          WEBATM
          VACC
          CVS
          BARCODE
          CUSTOM
          CVSCOM
          EZPAY
          EZPWECHAT
          EZPALIPAY
          LgsType
          TokenTerm
          BankType
          CREDITAGREEMENT
          OrderComment
          TokenLife
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
