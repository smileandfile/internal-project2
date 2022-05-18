require 'exceptions'

module Gsp
  module Eway
    module Endpoints
      class IrisEndpoint < BaseEndpoint
        attr_accessor :jwt_token
  
        def headers
          case environment
          when :staging
            {
              'client-id' => ENV['EWAY_STAGING_IRIS_CLIENT_ID'],
              'client-secret' => ENV['EWAY_STAGING_IRIS_CLIENT_SECRET']
            }
          when :production
            {
              'client-id' => ENV['EWAY_IRIS_CLIENT_ID'],
              'client-secret' => ENV['EWAY_IRIS_CLIENT_SECRET']
            }
          else
            raise(::GstnAspException, 'IRIS only supports staging and production')
          end
        end
  
        def env_to_endpoint_map
          {
            staging: ENV['EWAY_STAGING_IRIS_URL'],
            production: ENV['EWAY_IRIS_URL']
          }.freeze
        end
  
  
        private
      end
    end
  end
end