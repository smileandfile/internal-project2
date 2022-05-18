Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  ENV['HOST'] ||= 'gstn-asp.herokuapp.com'
  ENV['CC_AVENUE_WORKING_KEY'] ||= '19A0FFB3CE810FFA7C356399659B6EB4'
  ENV['CC_AVENUE_ACCESS_CODE'] ||= 'AVGR71EF59CE68RGEC'
  ENV['CC_AVENUE_MERCHANT_ID'] ||= '137357'
  ENV['SEND_GRID_API_KEY']  ||= ''
  ENV['RAILS_ENV'] ||= 'production'
  ENV['USE_GSTONE'] ||= 'true'
  ENV['NEW_RELIC_KEY'] ||= 'f21bdf5cf7ec3c0e0c250e42b794077acf9c24c6'
  ENV["PGHERO_USERNAME"] ||= "admin"
  ENV["PGHERO_PASSWORD"] ||= "password@123$"
  ENV['GSP_CLIENT_ID'] ||= 'l7xx0db84796716049edb7af8a3bf4eed6eb'
  ENV['GSP_SECRET_ID'] ||= '48ddaf4d65214b64a83ccc245380873a'

  ENV['EWAY_IRIS_CLIENT_ID'] ||= "1r159b748063c19d1c80c3bbdae370b84254"
  ENV['EWAY_IRIS_CLIENT_SECRET'] ||= "z1rcad4cef9045db1439ef70d9f5b9e54eb4"
  ENV['EWAY_STAGING_IRIS_CLIENT_ID'] ||= "1r159b748063c19d1c80c3bbdae370b84254"
  ENV['EWAY_STAGING_IRIS_CLIENT_SECRET'] ||= "z1rcad4cef9045db1439ef70d9f5b9e54eb4"
  ENV['EWAY_STAGING_IRIS_URL'] ||= "https://stage.esp.gsp.irisgst.com/ewaybillapi/v1.01"
  ENV['EWAY_IRIS_URL'] ||= "https://stage.esp.gsp.irisgst.com/ewaybillapi/v1.01"
  ENV['EWAY_CLIENT_ID'] ||= "test_gsp63"
  ENV['EWAY_CLIENT_SECRET'] ||= "OUJDMTIzQEB1BU1NXT1JE137"
  ENV["EWAY_USER_ID"] ||= "00ABLPK6554F000"
  ENV['EWAY_BASE_URL'] ||= "http://ewaybill2.nic.in/ewaybillapi/v1.01"
  ENV['STAGING_EWAY_CLIENT_ID'] ||= "test_gsp63"
  ENV['STAGING_EWAY_CLIENT_SECRET'] ||= "OUJDMTIzQEB1BU1NXT1JE137"
  ENV["STAGING_EWAY_USER_ID"] ||= "00ABLPK6554F000"
  ENV['STAGING_EWAY_BASE_URL'] ||= "https://ewaybill2.nic.in/ewaybillapi/v1.01"


  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "gstn-asp_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.smtp_settings = {
      :address              => "smtp.sendgrid.net",
      :port                 => 2525,
      :user_name            => 'apikey',
      :password             => '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',
      :authentication       => :plain,
      :enable_starttls_auto => true
  }

  config.action_mailer.default_options = {
    :from => 'no-reply@smileandfile.com'
  }
  host = 'https://' + ENV['HOST']
  config.action_mailer.default_url_options = {
    :host => host
  }
  config.action_mailer.asset_host = host


  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  Rails.application.config.middleware.use ExceptionNotification::Rack,
  :slack => {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#alert-bots"
  },
  # NOTE email config for exception handling
  :email => {
    :email_prefix => "GSTN ASP ERROR OCCURED ",
    :sender_address => %{"no-reply" <no-reply@smileandfile.com>},
    :exception_recipients => %w{ankit@coderbhai.com, mb@coderbhai.com, govindkeswani@gmail.com, deepesh.kherlavker@smileandfile.com}
  }
  
  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
