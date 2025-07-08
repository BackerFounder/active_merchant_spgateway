# frozen_string_literal: true

require 'uri'

module OffsitePayments
  module Integrations
    module Spgateway
      class Notification < OffsitePayments::Notification # :nodoc:
        PARAMS_FIELDS = %w[
          Status
          Message
          MerchantID
          Amt
          TradeNo
          MerchantOrderNo
          PaymentType
          RespondType
          CheckCode
          PayTime
          IP
          EscrowBank
          TokenUseStatus
          TokenValue
          RespondCode
          Auth
          Card6No
          Card4No
          Inst
          InstFirst
          InstEach
          ECI
          PayBankCode
          PayerAccount5Code
          CodeNo
          BankCode
          Barcode_1
          Barcode_2
          Barcode_3
          ExpireDate
          CheckCode
          TradeSha
          Version
          EncryptType
        ].freeze

        def initialize(post, options = {})
          @hash_key = options.delete(:hash_key) || OffsitePayments::Integrations::Spgateway.hash_key
          @hash_iv = options.delete(:hash_iv) || OffsitePayments::Integrations::Spgateway.hash_iv
          super(post, options)
        end

        PARAMS_FIELDS.each do |field|
          define_method field.underscore do
            @params[field]
          end
        end

        def trade_info
          return self if legacy?

          @trade_info ||= begin
            # TODO: 1. 如果解密失敗會是 false，然後會在 decode_www_form 出錯
            #       2. 如果 TradeInfo 是空的會出現 `ArgumentError: data must not be empty` 錯誤
            trade_info_params = Spgateway::EncryptData.decrypt(
              @params['TradeInfo'],
              hash_key,
              hash_iv
            )
            trade_info_params = URI.decode_www_form(trade_info_params).to_h
            Spgateway::Notification::TradeInfo.new(trade_info_params)
          end
        end

        def success?
          status == 'SUCCESS'
        end

        # TODO: 使用查詢功能實作 acknowledge
        # Pay2go 沒有遠端驗證功能，
        # 而以 checksum_ok? 代替
        def acknowledge
          checksum_ok?
        end

        def complete?
          %w[
            SUCCESS
            CUSTOM
          ].include? status
        end

        def encode_www_form
          URI.encode_www_form(params)
        end

        # `#checksum_ok?` 只支援藍新 API 2.0 的交易，因為一旦更新後，checksum_ok? 只會用於新交易
        # 過往交易不會再使用此方法做檢查，故不設計相容機制
        def checksum_ok?
          checksum = Spgateway::Checksum.generate(@params['TradeInfo'], hash_key, hash_iv)
          checksum == trade_sha
        end

        class TradeInfo # :nodoc:
          attr_reader :params

          TRADE_INFO_FIELDS = %w[
            Status
            Message
            MerchantID
            Amt
            TradeNo
            MerchantOrderNo
            PaymentType
            RespondType
            CheckCode
            PayTime
            IP
            EscrowBank
            AuthBank
            RespondCode
            Auth
            Card6No
            Card4No
            Inst
            InstFirst
            InstEach
            ECI
            TokenUseStatus
            TokenValue
            RedAmt
            PaymentMethod
            DCC_Amt
            DCC_Rate
            DCC_Markup
            DCC_Currency
            DCC_Currency_Code
            PayBankCode
            PayerAccount5Code
            CodeNo
            StoreType
            StoreID
            BankCode
            Barcode_1
            Barcode_2
            Barcode_3
            ExpireDate
            CheckCode
          ].freeze

          TRADE_INFO_FIELDS.each do |field|
            define_method field.underscore do
              @params[field]
            end
          end

          def initialize(params)
            @params = params
          end

          def encode_www_form
            URI.encode_www_form(params)
          end
        end

        private

        attr_reader :hash_key,
                    :hash_iv

        # 藍新 API 1.2 是直接將細節資料 expose 在第一層，沒有 TradeInfo 參數，到了 1.6 以上的版本則改成封裝在 TradeInfo 裡
        # 所以判斷如果沒有此參數則屬於 legacy 模式，使用舊的方式取得資料；如果有此參數，則可以使用新的方式取得資料。
        def legacy?
          @params['TradeInfo'].blank?
        end
      end
    end
  end
end
