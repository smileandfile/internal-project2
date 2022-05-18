require 'base64'
require 'openssl'
require 'logging'

CIPHER_TYPE = 'AES-256-ECB'.freeze
DIGEST_TYPE = 'SHA256'.freeze

# All the Crypto related code for the GSTN APIs
class GstnCrypto
  attr_accessor :GSTN_PUBLIC_KEY_SANDBOX
  attr_accessor :GSTN_PUBLIC_KEY_PRODUCTION
  attr_accessor :EWAY_PUBLIC_KEY_STAGING
  attr_accessor :EWAY_PUBLIC_KEY_PRODUCTION

  def initialize
    @logger = Logging.logger[self]
    self.GSTN_PUBLIC_KEY_SANDBOX = OpenSSL::PKey::RSA.new File.read gstn_key_file(true)
    self.GSTN_PUBLIC_KEY_PRODUCTION = OpenSSL::PKey::RSA.new File.read gstn_key_file(false)
    self.EWAY_PUBLIC_KEY_STAGING = OpenSSL::PKey::RSA.new File.read eway_key_file(true)
    self.EWAY_PUBLIC_KEY_PRODUCTION = OpenSSL::PKey::RSA.new File.read eway_key_file(false)
  end

  def gstn_key_file(is_sandbox)
    Rails.root + (is_sandbox ? 'app/lib/public_key_sandbox.pem' : 'app/lib/production_public.pem')
  end

  def eway_key_file(is_sandbox)
    Rails.root + (is_sandbox ? 'app/lib/staging_eway.pem' : 'app/lib/prod_eway.pem')
  end

  def encrypt_app_key_bytes(app_key, is_sandbox: true)
    @logger.info "Creating new encrypted key sandbox: #{is_sandbox}"
    key = is_sandbox ? self.GSTN_PUBLIC_KEY_SANDBOX : self.GSTN_PUBLIC_KEY_PRODUCTION
    encrypted_bytes = key.public_encrypt(app_key)
    base64_encode(encrypted_bytes)
  end

  def encrypt_app_key_bytes_eway(app_key, is_sandbox: true)
    @logger.info "Creating new eway encrypted key sandbox: #{is_sandbox}"
    key = is_sandbox ? self.EWAY_PUBLIC_KEY_STAGING : self.EWAY_PUBLIC_KEY_PRODUCTION
    encrypted_bytes = key.public_encrypt(app_key)
    base64_encode(encrypted_bytes)
  end

  # def encrypted_app_key
  #   @encrypted_app_key = encrypt_app_key(APPKEY) if @encrypted_app_key.nil?
  #   @encrypted_app_key
  # end

  def generate_new_app_key
    # previous method of genrating app key
    # cipher = OpenSSL::Cipher.new(CIPHER_TYPE)
    # cipher.encrypt
    # key = cipher.random_key
    # puts "NEW KEY #{key}"
    # key
    SecureRandom.random_bytes(32)
  end  

  def encrypted_app_key(app_key, is_sandbox: true)
    @encrypted_app_keys ||= {}
    key_name = (is_sandbox ? :sandbox : :production).to_s + app_key
    @encrypted_app_keys[key_name] = encrypt_app_key_bytes(app_key, is_sandbox: is_sandbox) if @encrypted_app_keys[key_name].nil?
    @encrypted_app_keys[key_name]
  end

  def encrypted_app_key_eway(app_key, is_sandbox: true)
    @encrypted_app_keys ||= {}
    key_name = (is_sandbox ? :sandbox : :production).to_s + app_key
    @encrypted_app_keys[key_name] = encrypt_app_key_bytes_eway(app_key, is_sandbox: is_sandbox) if @encrypted_app_keys[key_name].nil?
    @encrypted_app_keys[key_name]
  end


  def encrypt_data(data, key_bytes, encode_first = true, utf_encoding: false)

    encoded_data = utf_encoding ? base64_encode(data.force_encoding('UTF-8')).force_encoding('UTF-8') : base64_encode(data)

    base64_encoded_data = encode_first ? encoded_data : data

    cipher = OpenSSL::Cipher.new CIPHER_TYPE
    cipher.encrypt
    cipher.key = key_bytes

    encrypted = cipher.update base64_encoded_data
    encrypted << cipher.final

    base64_encode(encrypted)
  end


  def encrypt_data_eway(data, key_bytes)
    cipher = OpenSSL::Cipher.new CIPHER_TYPE
    cipher.encrypt
    cipher.key = key_bytes

    encrypted = cipher.update data
    encrypted << cipher.final

    base64_encode(encrypted)
  end


  def encrypt_otp(otp, app_key)
    encrypt_data(otp, app_key, false)
  end

  def decrypt_data(data, key)
    base64_encode(decrypt_data_without_encode(data, key))
  end

  def decrypt_data_without_encode(data, key)
    base64_decoded_data = Base64.strict_decode64(data)

    cipher = OpenSSL::Cipher.new CIPHER_TYPE
    cipher.decrypt
    cipher.key = key

    decrypted = cipher.update base64_decoded_data
    decrypted << cipher.final

    decrypted
  end

  def decrypt_api_response(data, sek_base64, rek, upstream_hmac = '')
    ek = Base64.decode64 sek_base64
    api_ek = decrypt_data_without_encode rek, ek

    Rails.logger.info "EK #{ek}\nAPI_EK #{api_ek}"

    encoded_json = decrypt_data_without_encode data, api_ek
    json = Base64.decode64 encoded_json

    test_hmac = hmac_256(json, api_ek)
    Rails.logger.info "Generated HMAC vs Upstream HMAC #{test_hmac == upstream_hmac}\n#{test_hmac} vs #{upstream_hmac}"
    Rails.logger.info "Decrypted Response #{json}"


    json
  end

  def hmac_256(data, key_bytes)
    Rails.logger.info("HMAC 256\nKEY: #{key_bytes}\nDATA: #{data}")
    hmac = base64_encode OpenSSL::HMAC.digest(DIGEST_TYPE,
                                              key_bytes,
                                              base64_encode(data))
    Rails.logger.info("HMAC 256\n#{hmac}")
    hmac
  end

  def base64_encode(data)
    Base64.encode64(data).gsub(/\n/, '')
  end
end
