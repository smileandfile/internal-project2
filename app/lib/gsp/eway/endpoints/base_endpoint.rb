require 'exceptions'

module Gsp
  module Eway
    module Endpoints
      class BaseEndpoint
        ENVIRONMENTS = %i[staging production].freeze
  
        attr_accessor :environment
        def initialize(environment = ENVIRONMENTS.staging)
          self.environment = environment.to_sym
        end
  
        def headers
          {}
        end
  
        def before_request(*); end
  
        def base_url
          raise(::GstnAspException, 'Does not match Environment') unless matches
          env_to_endpoint_map[environment]
        end
  
        def env_to_endpoint_map
          {}.freeze
        end
  
  
        def matches
          env_to_endpoint_map.include?(environment)
        end
      end
    end
  end
end