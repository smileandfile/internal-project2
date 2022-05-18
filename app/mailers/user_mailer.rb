require 'wicked_pdf'
require 'rails_admin'

class UserMailer < ApplicationMailer

  def new_user_created(new_user)
    @new_user = new_user
    mail(to: @new_user.email, subject: "User added on Domain #{@new_user.domain.name.upcase} on Smile and File Portal")
  end

  def new_user_otp_email(new_user)
    @new_user = new_user
    subject = new_user.user? ? "User Activation on Smile and File - OTP" : "Activation of Domain created on Smile and File Portal"
    mail(to: @new_user.email, subject: subject)
  end

  def domain_created(new_domain)
    @new_domain = new_domain
    mail(to: @new_domain.user.email, subject: "Domain #{@new_domain.name.upcase} created on Smile and File Portal")
  end

  def send_offline_payment_mail(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: "Payment Details for domain #{@user.domain.name.upcase} activation on Smile and File Portal")
  end

  def send_invoice(order)
    @current_user = order.user
    @order = order
    body_html = render_to_string('shared/_invoice.html.erb',
                                 layout: 'layouts/pdf.pdf.erb')
    @pdf = WickedPdf.new.pdf_from_string(body_html)
    attachments["invoice_#{order.invoice_number}.pdf"] = @pdf
    mail(to: @current_user.email, subject: "Payment Details / invoice details for domain activation on Smile and File Portal")
  end

  def send_logs(abstract_class, schema_data, mail_address = 'gsp@shalibhadrafinance.com', from_date, to_date)
    if abstract_class.model_name == "GstAccessItem"
      @objects = abstract_class.model_name.constantize.where("requested_at >= ? AND requested_at <= ?", from_date, to_date)
    else
      @objects = abstract_class.model_name.constantize.where("created_at >= ? AND created_at <= ?", from_date, to_date)
    end
    output  = RailsAdmin::CSVConverter.new(@objects, schema_data).to_csv()
    attachments["api_log-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"] = output
    mail(to: mail_address, subject: "Api logs for GSTN #{abstract_class.model_name}")
  end

  def user_support(contact, user = nil)
    @contact = contact
    subject = user.nil? ? "Suppport required - Web App" : "Suppport required - Web App - Domain #{user.domain.name.upcase}"
    mail(to: 'support@smileandfile.com', subject: subject)
  end

  def user_feedback(feedback)
    @feedback = feedback
    mail(to: 'support@smileandfile.com', subject: "Feedback required - Web App - Domain #{feedback.domain.upcase}")
  end

  def payment_url_mail(order)
    @order = order
    @payment_url = online_payment_if_gateway_failure_dashboard_order_url(order) + '?' + { token: order.token}.to_query
    mail(to: order.billing_email, subject: "Payment URL for activation of domain #{order.user.domain.name.upcase}")
  end

end
