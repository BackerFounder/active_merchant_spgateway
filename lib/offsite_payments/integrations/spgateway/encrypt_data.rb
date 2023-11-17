# frozen_string_literal: true

require 'openssl'

module OffsitePayments
  module Integrations
    module Spgateway
      class EncryptData # :nodoc:
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

          def strippadding(string)
            slast = string[-1].ord
            slastc = slast.chr
            if string.match(/#{slastc * slast}/)
              string[0..-slast - 1]
            else
              false
            end
          end
        end
      end
    end
  end
end
