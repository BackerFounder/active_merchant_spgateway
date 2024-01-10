# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Spgateway
      # 根據文件：線上交易 - 幕前支付技術串接手冊
      # 文件版本：NDNF-1.0.9
      # 章節：4.1.5 & 4.1.6
      class Checksum
        class << self
          # 藍新文件的 checksum、check_code、check_value 的計算方式都是使用 SHA256 來計算，可是前綴跟後綴的的格式不同，所以設計參數來決定前綴跟後綴的格式。
          def generate(params, prefixer, suffixer, prefixer_format: 'HashKey', suffixer_format: 'HashIV')
            content = "#{prefixer_format}=#{prefixer}&#{params}&#{suffixer_format}=#{suffixer}"
            Digest::SHA256.hexdigest(content).upcase
          end
        end
      end
    end
  end
end
