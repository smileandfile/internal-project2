module Gsp
  module Endpoints
    class GspOneEndpoint < BaseEndpoint
      attr_accessor :jwt_token

      def base_headers
        case environment
        when :production
          {
            clientid: ENV['GSP_CLIENT_ID'],
            'client-secret' => ENV['GSP_SECRET_ID']
          }
        else
          {
            clientid: 'l7xxbd1169e4eaed40c99317351fc9de09d0',
            'client-secret' => '13d2d87f265c46569cf11e84bdd53748'
          }
        end  
      end

      def headers
        base_headers.merge!(Authorization: jwt_token)
      end

      def before_request(client)
        authenticate(client) if jwt_token.nil?
      end

      def env_to_endpoint_map
        {
          staging: 'http://preprod.gstone.in',
          preprod: 'http://gstn-preproduction.gstone.in',
          production: 'https://api.gstone.in'
        }.freeze
      end

      private

      ### This provides authentication with gstone.in
      def authenticate(client, username = 'madhav', password = 'nnf1q')
        if environment == :production
          username = 'Smileandfile'
          password = 'hdedn9duy16wbz7k'
        end
        headers = self.base_headers.merge!('Content-Type' => 'application/x-www-form-urlencoded')
        client.class.base_uri base_url
        body = {
                payload: {
                  username: username,
                  something: 'some random thing'
                  }.to_json
              }
        action = '/auth/'        
        response = client.class.post action,
                                     headers: headers,
                                     basic_auth: {
                                       username: username,
                                       password: password
                                     },
                                     body: body
        if response.code == 401
          client.audit_request_for_unauthorized_gstone(headers, body, action, response) 
        end                              
        self.jwt_token = response.parsed_response['token']
        response.response.error! unless response.success?
        Rails.logger.info '**GspOne** JWT TOKEN: ' + jwt_token unless response.parsed_response['token'].nil?
        response
      end
    end
  end
end