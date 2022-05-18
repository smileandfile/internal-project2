
module Gsp
  module Endpoints
    class DirectEndpoint < BaseEndpoint
      attr_accessor :jwt_token

      def headers
        {
          clientid: 'l7xxbd1169e4eaed40c99317351fc9de09d0',
          'client-secret' => '13d2d87f265c46569cf11e84bdd53748'
        }
      end

      def env_to_endpoint_map
        {
          staging: 'https://devapi.gstsystem.co.in'
        }.freeze
      end

      def before_request(client)

        # NOTE
        # use lightsail server running in mumbai as GSTN requires Indian IPs
        # this will not be required when going through GSTONE.in
        client.class.http_proxy(ENV['PROXY_ADDRESS'] || '13.126.115.131',
                                ENV['PROXY_PORT'] || 3128,
                                ENV['PROXY_USER'] || 'user',
                                ENV['PROXY_PASSWORD'] || 'Password@123$')
      end

    end
  end
end