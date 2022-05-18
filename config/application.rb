require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENV['RAILS_ADMIN_THEME'] = 'rollincode'

module GstnAsp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    config.active_job.queue_adapter = :delayed_job
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.time_zone = "Kolkata"
    config.active_record.default_timezone = :utc
    # This will route any exceptions caught to your router Rack app
    config.exceptions_app = self.routes


  end
end
