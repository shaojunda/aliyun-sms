require 'aliyun/sms'
describe Aliyun::Sms do

  describe "#configure" do
    before do
      Aliyun::Sms.configure do |config|
        config.access_key_secret = 'testsecret'
        config.access_key_id = 'testid'
        config.action = 'SendSms'
        config.format = 'JSON'
        config.region_id = 'cn-hangzhou'
        config.sign_name = '标签测试'
        config.signature_method = 'HMAC-SHA1'
        config.signature_version = '1.0'
        config.sms_version = '2017-05-25'
      end
    end

    it "get query string through configurated itmes" do
      config = Aliyun::Sms.configuration
      method_input = {
        'AccessKeyId' => config.access_key_id,
        'Action' => config.action,
        'Format' => config.format,
        'PhoneNumbers' => '13098765432',
        'RegionId' => config.region_id,
        'SignName' => config.sign_name,
        'SignatureMethod' => config.signature_method,
        'SignatureNonce' => '9e030f6b-03a2-40f0-a6ba-157d44532fd0',
        'SignatureVersion' => config.signature_version,
        'TemplateCode' => 'SMS_1650053',
        'TemplateParam' => '{"name":"d","name1":"d"}',
        'Timestamp' => '2016-10-20T05:37:52Z',
        'Version' => config.sms_version,
        }

      spect_output = 'AccessKeyId=testsecret&Action=testid&Format=JSON&PhoneNumbers=13098765432&RegionId=cn-hangzhou&SignName=%E6%A0%87%E7%AD%BE%E6%B5%8B%E8%AF%95&SignatureMethod=HMAC-SHA1&SignatureNonce=9e030f6b-03a2-40f0-a6ba-157d44532fd0&SignatureVersion=1.0&TemplateCode=SMS_1650053&TemplateParam=%7B%22name%22%3A%22d%22%2C%22name1%22%3A%22d%22%7D&Timestamp=2016-10-20T05%3A37%3A52Z&Version=2017-05-25'

      expect(Aliyun::Sms.query_string(method_input)).to eql(spect_output)
    end
  end

  it "get the query string" do
    method_input = {
        'AccessKeyId' => 'testid',
        'Action' => 'SingleSendSms',
        'Format' => 'XML',
        'PhoneNumbers' => '13098765432',
        'RegionId' => 'cn-hangzhou',
        'SignName' => '标签测试',
        'SignatureMethod' => 'HMAC-SHA1',
        'SignatureNonce' => '9e030f6b-03a2-40f0-a6ba-157d44532fd0',
        'SignatureVersion' => '1.0',
        'TemplateCode' => 'SMS_1650053',
        'TemplateParam' => '{"name":"d","name1":"d"}',
        'Timestamp' => '2016-10-20T05:37:52Z',
        'Version' => "2017-05-25"
      }
    spect_output = 'AccessKeyId=testsecret&Action=testid&Format=JSON&PhoneNumbers=13098765432&RegionId=cn-hangzhou&SignName=%E6%A0%87%E7%AD%BE%E6%B5%8B%E8%AF%95&SignatureMethod=HMAC-SHA1&SignatureNonce=9e030f6b-03a2-40f0-a6ba-157d44532fd0&SignatureVersion=1.0&TemplateCode=SMS_1650053&TemplateParam=%7B%22name%22%3A%22d%22%2C%22name1%22%3A%22d%22%7D&Timestamp=2016-10-20T05%3A37%3A52Z&Version=2017-05-25'

    expect(Aliyun::Sms.query_string(method_input)).to eql(spect_output)
  end

  it "get the canonicalized query string" do
    method_input = {
        'AccessKeyId' => 'testid',
        'Action' => 'SingleSendSms',
        'Format' => 'XML',
        'PhoneNumbers' => '13098765432',
        'RegionId' => 'cn-hangzhou',
        'SignName' => '标签测试',
        'SignatureMethod' => 'HMAC-SHA1',
        'SignatureNonce' => '9e030f6b-03a2-40f0-a6ba-157d44532fd0',
        'SignatureVersion' => '1.0',
        'TemplateCode' => 'SMS_1650053',
        'TemplateParam' => '{"name":"d","name1":"d"}',
        'Timestamp' => '2016-10-20T05:37:52Z',
        'Version' => "2017-05-25"
      }
    spect_output = 'AccessKeyId%3Dtestsecret%26Action%3Dtestid%26Format%3DJSON%26PhoneNumbers%3D13098765432%26RegionId%3Dcn-hangzhou%26SignName%3D%25E6%25A0%2587%25E7%25AD%25BE%25E6%25B5%258B%25E8%25AF%2595%26SignatureMethod%3DHMAC-SHA1%26SignatureNonce%3D9e030f6b-03a2-40f0-a6ba-157d44532fd0%26SignatureVersion%3D1.0%26TemplateCode%3DSMS_1650053%26TemplateParam%3D%257B%2522name%2522%253A%2522d%2522%252C%2522name1%2522%253A%2522d%2522%257D%26Timestamp%3D2016-10-20T05%253A37%253A52Z%26Version%3D2017-05-25'

    expect(Aliyun::Sms.canonicalized_query_string(method_input)).to eql(spect_output)
  end

  it "get sign" do
    method_input = {
        'AccessKeyId' => 'testid',
        'Action' => 'SingleSendSms',
        'Format' => 'XML',
        'PhoneNumbers' => '13098765432',
        'RegionId' => 'cn-hangzhou',
        'SignName' => '标签测试',
        'SignatureMethod' => 'HMAC-SHA1',
        'SignatureNonce' => '9e030f6b-03a2-40f0-a6ba-157d44532fd0',
        'SignatureVersion' => '1.0',
        'TemplateCode' => 'SMS_1650053',
        'TemplateParam' => '{"name":"d","name1":"d"}',
        'Timestamp' => '2016-10-20T05:37:52Z',
        'Version' => "2017-05-25"
      }
    key = 'testsecret'

    spect_output = 'ojMFINPAOjMJ2x5PQe6u2XM57Mw%3D'

    expect(Aliyun::Sms.sign(key, params_input)).to eql(spect_output)
  end

  it "get post body data" do
    method_input = {
        'AccessKeyId' => 'testid',
        'Action' => 'SingleSendSms',
        'Format' => 'XML',
        'PhoneNumbers' => '13098765432',
        'RegionId' => 'cn-hangzhou',
        'SignName' => '标签测试',
        'SignatureMethod' => 'HMAC-SHA1',
        'SignatureNonce' => '9e030f6b-03a2-40f0-a6ba-157d44532fd0',
        'SignatureVersion' => '1.0',
        'TemplateCode' => 'SMS_1650053',
        'TemplateParam' => '{"name":"d","name1":"d"}',
        'Timestamp' => '2016-10-20T05:37:52Z',
        'Version' => "2017-05-25"
      }
    key = 'testsecret'

    spect_output = 'Signature=ojMFINPAOjMJ2x5PQe6u2XM57Mw%3D&AccessKeyId=testsecret&Action=testid&Format=JSON&PhoneNumbers=13098765432&RegionId=cn-hangzhou&SignName=%E6%A0%87%E7%AD%BE%E6%B5%8B%E8%AF%95&SignatureMethod=HMAC-SHA1&SignatureNonce=9e030f6b-03a2-40f0-a6ba-157d44532fd0&SignatureVersion=1.0&TemplateCode=SMS_1650053&TemplateParam=%7B%22name%22%3A%22d%22%2C%22name1%22%3A%22d%22%7D&Timestamp=2016-10-20T05%3A37%3A52Z&Version=2017-05-25'

    expect(Aliyun::Sms.post_body_data(key, params_input)).to eql(spect_output)
  end

end
