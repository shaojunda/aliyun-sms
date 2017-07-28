require "aliyun/sms/version"
require "openssl"
require "base64"
require "typhoeus"
require "erb"
require "uuid"
include ERB::Util

module Aliyun
  module Sms
    class Configuration
      attr_accessor :access_key_secret, :access_key_id, :action, :format, :region_id,
                    :sign_name, :signature_method, :signature_version, :sms_version
      def initialize
        @access_key_secret = ""
        @access_key_id = ""
        @action = ""
        @format = ""
        @region_id = ""
        @sign_name = ""
        @signature_method = ""
        @signature_version = ""
        @sms_version = ""
      end
    end

    class << self
      attr_writer :configuration

      API_URL = 'http://dysmsapi.aliyuncs.com/'

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def create_params(mobile_num, template_code, message_param)
        {
          'AccessKeyId' => configuration.access_key_id,
          'Action' => configuration.action,
          'Format' => configuration.format,
          'PhoneNumbers' => mobile_num,
          'RegionId' => configuration.region_id,
          'SignName' => configuration.sign_name,
          'SignatureMethod' => configuration.signature_method,
          'SignatureNonce' => seed_signature_nonce,
          'SignatureVersion' => configuration.signature_version,
          'TemplateCode' => template_code,
          'TemplateParam' => message_param,
          'Timestamp' => seed_timestamp,
          'Version' => configuration.sms_version,
        }
      end

      def send(mobile_num, template_code, message_param)
        sms_params = create_params(mobile_num, template_code, message_param)
        post_body = post_body_data(configuration.access_key_secret, sms_params)
        Typhoeus.post(API_URL,
                 headers: { "Content-Type" => "application/x-www-form-urlencoded" },
                 body: post_body)
      end

      # 原生参数拼接成请求字符串
      def query_string(params)
        q_string = ''
        params.each do |key, value|
          if q_string.empty?
            q_string += "#{encode(key)}=#{encode(value)}"
          else
            q_string += "&#{encode(key)}=#{encode(value)}"
          end
        end
        q_string
      end

      # 原生参数经过2次编码拼接成标准字符串
      def canonicalized_query_string(params)
        c_q_string = ''
        params.each do |key, value|
          if c_q_string.empty?
            c_q_string += "#{encode(key)}=#{encode(value)}"
          else
            c_q_string += "&#{encode(key)}=#{encode(value)}"
          end
        end
        encode(c_q_string)
      end

      # 生成数字签名
      def sign(key_secret, params)
        key = key_secret + '&'
        signature = 'POST' + '&' + encode('/') + '&' + canonicalized_query_string(params)
        sign = Base64.encode64("#{OpenSSL::HMAC.digest('sha1', key, signature)}")
        encode(sign.chomp)  # 通过chomp去掉最后的换行符 LF
      end

      # 组成附带签名的 POST 方法的 BODY 请求字符串
      def post_body_data(key_secret, params)
        'Signature=' + sign(key_secret, params) + '&' + query_string(params)
      end

      # 对字符串进行 PERCENT 编码
      def encode(input)
        url_encode(input)
      end

      # 生成短信时间戳
      def seed_timestamp
        Time.now.utc.strftime("%FT%TZ")
      end

      # 生成短信唯一标识码，采用到微秒的时间戳
      def seed_signature_nonce
        UUID.generate
      end
    end
  end
end
