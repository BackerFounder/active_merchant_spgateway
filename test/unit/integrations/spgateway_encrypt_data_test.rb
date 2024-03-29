# frozen_string_literal: true

require 'test_helper'

class SpgatewayEncryptDataTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup; end

  def test_encrypt
    params = 'MerchantID=MS127874575&RespondType=String&TimeStamp=1695795410&Version=2.0&MerchantOrderNo=Vanespl_ec_1695795410&Amt=30&ItemDesc=test&NotifyURL=https%3A%2F%2Fwebhook.site%2Fd4db5ad1-2278-466a-9d66-78585c0dbadb' # rubocop:disable Layout/LineLength
    result = Spgateway::EncryptData.encrypt(params, 'Fs5cX1TGqYM2PpdbE14a9H83YQSQF5jn', 'C6AcmfqJILwgnhIP')

    # 此測試結果為藍新文件提供的範例
    assert_equal 'f79eac33c4f3245d58f17b544c5d38b09457a6d77e77bae6f10fcc7236fe153ccef1a80001c0746afc063a7570f80ad970d8a32c72332c9ec5547410188007876bdca2bafa52d07d31b6b183f2204d6e4feee6d245e286ab198cf95422ad5843c7696fc943cbb65979ad207607d4b5d97dac4a90ccd5e7a37adb7d7062e838be09d94e8c5dfa145c048e17feabe58c2e310792f0f50f5af32961ffb07ff6649ae1021ad558242551de5f09316e3182e198775e5d1ad5b66a70be290004de750fa85d86b0c2f087b40005d89e048be2ab6fd83f1c522494c093426a10a1f73fe4', # rubocop:disable Layout/LineLength
                 result
  end

  def test_decrypt
    params = 'ee11d1501e6dc8433c75988258f2343d11f4d0a423be672e8e02aaf373c53c2363aeffdb4992579693277359b3e449ebe644d2075fdfbc10150b1c40e7d24cb215febefdb85b16a5cde449f6b06c58a5510d31e8d34c95284d459ae4b52afc1509c2800976a5c0b99ef24cfd28a2dfc8004215a0c98a1d3c77707773c2f2132f9a9a4ce3475cb888c2ad372485971876f8e2fec0589927544c3463d30c785c2d3bd947c06c8c33cf43e131f57939e1f7e3b3d8c3f08a84f34ef1a67a08efe177f1e663ecc6bedc7f82640a1ced807b548633cfa72d060864271ec79854ee2f5a170aa902000e7c61d1269165de330fce7d10663d1668c711571776365bfdcd7ddc915dcb90d31a9f27af9b79a443ca8302e508b0dbaac817d44cfc44247ae613075dde4ac960f1bdff4173b915e4344bc4567bd32e86be7d796e6d9b9cf20476e4996e98ccc315f1ed03a34139f936797d971f2a3f90bc18f8a155a290bcbcf04f4277171c305bf554f5cba243154b30082748a81f2e5aa432ef9950cc9668cd4330ef7c37537a6dcb5e6ef01b4eca9705e4b097cf6913ee96e81d0389e5f775' # rubocop:disable Layout/LineLength
    result = Spgateway::EncryptData.decrypt(params, 'Fs5cX1TGqYM2PpdbE14a9H83YQSQF5jn', 'C6AcmfqJILwgnhIP')

    assert_equal 'Status=SUCCESS&Message=%E6%8E%88%E6%AC%8A%E6%88%90%E5%8A%9F&MerchantID=MS127874575&Amt=30&TradeNo=23092714215835071&MerchantOrderNo=Vanespl_ec_1695795668&RespondType=String&IP=123.51.237.115&EscrowBank=HNCB&PaymentType=CREDIT&RespondCode=00&Auth=115468&Card6No=400022&Card4No=1111&Exp=2609&AuthBank=KGI&TokenUseStatus=0&InstFirst=0&InstEach=0&Inst=0&ECI=&PayTime=2023-09-27+14%3A21%3A59&PaymentMethod=CREDIT', # rubocop:disable Layout/LineLength
                 result
  end
end
