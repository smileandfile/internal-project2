require 'logging'

SIGNZY_ESIGN_USER = 'gstone_ravi_test_1'.freeze
SIGNZY_ESIGN_PASSWORD = 'L13VGQT8mfdqnmcXZaFlPFCbwCEv9yYjeMq6ciGU'.freeze
SIGNZY_TOKEN_EXPIRY_PADDING_MINUTES = 2

class SignzyEsigner
  include HTTParty

  base_uri 'https://signzy.tech/api/v2/patrons/'
  debug_output $stdout

  attr_accessor :authorization_token
  attr_accessor :authorization_expiry_time
  attr_accessor :user_id

  def initialize
    @logger = Logging.logger[self]
  end

  def login(user = SIGNZY_ESIGN_USER,
            password = SIGNZY_ESIGN_PASSWORD)
    response = self.class.post '/login',
                               body: {
                                 username: user,
                                 password: password
                               }

    raise 'SignzyLoginException' unless response.success?

    self.authorization_token = response.parsed_response['id']
    self.authorization_expiry_time = Time.now + Integer(response.parsed_response['ttl']).seconds
    self.user_id = response.parsed_response['userId']
  end

  def otp_request(aadhaar_number:)
    ensure_signed_in!
    secure_post "/#{user_id}/aadhaaresigns",
                request: 'otp',
                essentials: {
                  uid: aadhaar_number
                }

  end

  def hash_sign(aadhaar_number:, otp:, hash:)
    ensure_signed_in!
    secure_post "/#{user_id}/aadhaaresigns",
                request: 'hash-sign',
                essentials: {
                  uid: aadhaar_number,
                  hash: hash,
                  otp: otp
                }
  end

  protected

  def secure_post(url, body)
    ensure_signed_in!
    response = self.class.post url,
                               body: body,
                               headers: {
                                 Authorization: authorization_token
                               }
    raise 'UpstreamSignzyError' unless response.success?
    response.parsed_response
  end

  def ensure_signed_in!
    login unless authorization_expiry_time.present? && \
                 (authorization_expiry_time + SIGNZY_TOKEN_EXPIRY_PADDING_MINUTES.minutes) > Time.now
  end
end