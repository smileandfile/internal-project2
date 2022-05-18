module Gsp
  module Eway
    module Endpoints
      class GspOneEndpoint < BaseEndpoint
  
        def base_headers
          case environment
          when :production
            {
              'client-id' => ENV['EWAY_CLIENT_ID'],
              'client-secret' => ENV['EWAY_CLIENT_SECRET'],
              'ewb-user-id'  => ENV['EWAY_USER_ID']
            }
          else
            {
              'client-id' => ENV['STAGING_EWAY_CLIENT_ID'],
              'client-secret' => ENV['STAGING_EWAY_CLIENT_SECRET'],
              'ewb-user-id'  => ENV['STAGING_EWAY_USER_ID']
            }
          end  
        end
  
        def headers
          base_headers
        end
  
        def env_to_endpoint_map
          {
            staging: ENV['STAGING_EWAY_BASE_URL'],
            production: ENV['EWAY_BASE_URL']
          }.freeze
        end
      end
    end
  end
end