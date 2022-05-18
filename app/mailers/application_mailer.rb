class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  helper ApplicationHelper
  #TODO this should be updated
  default from: 'no-reply@smileandfile.com'
end
