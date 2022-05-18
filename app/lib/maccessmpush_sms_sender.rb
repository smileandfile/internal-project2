class MaccessmpushSMSSender
  include HTTParty
  base_uri 'https://otp2.maccesssmspush.com/OTP_ACL_Web'

  debug_output $stdout

  unless ENV['SMS_SKIP_PROXY']
    # NOTE
    # TODO
    # use lightsail server running in mumbai as SMS Sender requires fixed IP address
    # this will not be required when going through GSTONE.in
    http_proxy(ENV['PROXY_ADDRESS'] || '13.126.115.131',
               ENV['PROXY_PORT'] || 3128,
               ENV['PROXY_USER'] || 'user',
               ENV['PROXY_PASSWORD'] || 'Password@123$')
  end

  def send_sms(phone_number, msg)
    query_params = {
      enterpriseid: 'shabdotp',
      subEnterpriseid: 'shabdotp',
      pusheid: 'shabdotp',
      pushepwd: 'shabdotp3',
      msisdn: phone_number.to_i,
      sender: 'SMILEF',
      msgtext: msg
    }

    self.class.base_uri 'https://otp2.maccesssmspush.com/OTP_ACL_Web'
    url = '/OtpRequestListener?' + query_params.to_query
    Rails.logger.info "SMS SEND URL - #{url}"
    self.class.post(url)
  end

  def send_sms_transactional(phone_number, msg)
    query_params = {
      userId: 'shabdralt',
      pass: 'shabdralt26',
      appid: 'shabdralt',
      subappid: 'shabdralt',
      to: phone_number.to_i,
      from: 'SMILEF',
      text: msg,
      contenttype: 1,
      selfid: true,
      alert: 1,
      dlrreq: true

    }
    self.class.base_uri "https://push3.maccesssmspush.com/servlet"
    url = '/com.aclwireless.pushconnectivity.listeners.TextListener?' + query_params.to_query
    Rails.logger.info "SMS SEND URL - #{url}"
    self.class.post(url)
  end

  def domain_created(user)
    # new message
    msg = "Hello! #{user.otp_code} is your Smile and File code for validation of your" \
          " Mobile number. The OTP shall expire in 10 minutes. Do not share with anyone." \
          " Have a good day!"

          send_sms(user.phone_number, msg)
  end

  def domain_active(domain)
    msg = "Congratulations! Your domain #{domain.name.upcase} on the Smile and File" \
          " portal is ready. Please create entities, gstin and users in the domain" \
          " and download the software."
    send_sms_transactional(domain.user.phone_number, msg)
  end

  def new_user_created(user)
    msg = "Hello! You are a new user on the domain #{user.domain.name.upcase} on" \
          " Smile and File portal. Please lookout for an email sent to login to" \
          " activate your account. Have a good day!"
    send_sms_transactional(user.phone_number, msg)
  end

end
