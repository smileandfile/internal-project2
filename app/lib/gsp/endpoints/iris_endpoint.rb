require 'exceptions'

module Gsp
  module Endpoints
    class IrisEndpoint < BaseEndpoint
      attr_accessor :jwt_token

      def headers
        case environment
        when :staging
          {
            clientid: 'l7xxbd1169e4eaed40c99317351fc9de09d0',
            'client-secret' => '13d2d87f265c46569cf11e84bdd53748'
          }
        when :production
          {
            clientid: 'l7xx9debf393550149beafc990d74e7a4942',
            'client-secret' => '4d838b0e26f847e99140100b4d6e8eff'
          }
        else
          raise(::GstnAspException, 'IRIS only supports staging and production')
        end
      end

      def env_to_endpoint_map
        {
          staging: 'https://stage.gsp.irisgst.com',
          production: 'https://gsp.irisgst.com'
        }.freeze
      end


      private
    end
  end
end