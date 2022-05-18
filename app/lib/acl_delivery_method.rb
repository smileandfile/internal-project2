class AclDeliveryMethod
  include HTTParty

  ACL_MAILER_API_KEY = ENV['ACL_MAILER_API_KEY'] || '6835ae677ea18cb53705caf7f4617945'.freeze
  ACL_MAILER_USER = ENV['ACL_MAILER_USER'] || 'Sh@li123'.freeze
  ACL_MAILER_BASE_URL = 'http://api.maileracl.co.in'.freeze

  base_uri ACL_MAILER_BASE_URL
  debug_output $stdout # <= will spit out all request details to the console

  def initialize(*)
  end

  def prepare_payload(mail)
    recipients_block = mail.to.map { |email| "<Recipient><EmailId>#{email}</EmailId></Recipient>"}.join('')

    %(<?xml version="1.0" encoding="UTF-8"?>
      <MailSend>
        <ApiKey>#{ACL_MAILER_API_KEY}</ApiKey>
        <Password>#{ACL_MAILER_USER}</Password>
        <Request>
          <Mail>
            <Subject>#{Base64.strict_encode64(mail.subject.to_s)}</Subject>
            <FromName>#{Base64.strict_encode64('Smile And File')}</FromName>
            <FromEmail>gsp@smileandfile.com</FromEmail>
            <ReplyTo>gsp@smileandfile.com</ReplyTo>
            <Format>2</Format>
            <ContentSource>1</ContentSource>
            <Content>#{Base64.strict_encode64(mail.body.to_s)}</Content>
            <AutoUnsubscribeLink>1</AutoUnsubscribeLink>
          </Mail>
          <Recipients>
            #{recipients_block}
          </Recipients>
        </Request>
      </MailSend>)
  end

  def deliver!(mail)
    body = prepare_payload(mail)

    response = self.class.post '/v3.1/?mail/send',
                               headers: {
                                 'Content-Type': 'application/x-www-form-urlencoded'
                               },
                               body: {
                                 Request: body
                              }

    raise 'DeliveryException' unless response.success?

  end
end