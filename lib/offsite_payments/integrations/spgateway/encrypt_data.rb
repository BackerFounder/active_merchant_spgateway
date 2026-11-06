# frozen_string_literal: true

require 'openssl'

module OffsitePayments
  module Integrations
    module Spgateway
      class EncryptData # :nodoc:
        PADDING_BLOCK_SIZE = 32

        class << self
          def encrypt(content, hash_key, hash_iv)
            cipher = OpenSSL::Cipher.new('AES-256-CBC')
            cipher.encrypt
            cipher.key = hash_key
            cipher.iv = hash_iv
            encrypted = cipher.update(content) + cipher.final
            encrypted.unpack1('H*')
          end

          def decrypt(encrypted, hash_key, hash_iv)
            cipher = OpenSSL::Cipher.new('AES-256-CBC')
            cipher.decrypt
            cipher.padding = 0
            cipher.key = hash_key
            cipher.iv = hash_iv
            decrypted = cipher.update([encrypted].pack('H*')) + cipher.final
            strippadding(decrypted)
          end

          private

          # 去掉藍新 PKCS7 padding（block size 32），padding 不合法回傳 false
          # 不用正則比對，避免用解密內容組出動態正則
          def strippadding(string)
            pad = string.getbyte(-1)
            return false if pad.nil? || pad < 1 || pad > PADDING_BLOCK_SIZE
            return false if pad > string.bytesize
            return false unless string.byteslice(-pad, pad).each_byte.all?(pad)

            string.byteslice(0, string.bytesize - pad)
          end
        end
      end
    end
  end
end
