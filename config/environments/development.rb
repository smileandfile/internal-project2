Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  ENV['HOST'] ||= 'localhost:3000'
  ENV['CC_AVENUE_WORKING_KEY'] ||= '0CDACBCDB4D3CEDE69EE7849EE56B213'
  ENV['CC_AVENUE_ACCESS_CODE'] ||= 'AVYZ71EF60CE33ZYEC'
  ENV['CC_AVENUE_MERCHANT_ID'] ||= '137357'
  ENV['USE_GSTONE'] ||= 'true'
  ENV['RAILS_ENV'] ||= 'development'
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
  ENV['EWAY_BASE_URL'] ||= "http://ewaybill2.nic.in/ewaybillapi/v1.03"
  ENV['STAGING_EWAY_CLIENT_ID'] ||= "test_gsp63"
  ENV['STAGING_EWAY_CLIENT_SECRET'] ||= "OUJDMTIzQEB1BU1NXT1JE137"
  ENV["STAGING_EWAY_USER_ID"] ||= "00ABLPK6554F000"
  ENV['STAGING_EWAY_BASE_URL'] ||= "https://ewaybill2.nic.in/ewaybillapi/v1.03"




  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.smtp_settings = {
      :address              => "smtp.sendgrid.net",
      :port                 => 2525,
      :domain               => 'aspone.in',
      :user_name            => 'apikey',
      :password             => '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',
      :authentication       => :plain,
      :enable_starttls_auto => true
  }

  config.action_mailer.default_options = {
    :from => 'no-reply@smileandfile.com'
  }
  config.action_mailer.delivery_method =  :smtp


  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
