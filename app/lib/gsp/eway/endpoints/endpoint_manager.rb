require 'exceptions'

module Gsp
  module Eway
    module Endpoints
      class EndpointManager
        ORDERED_ENDPOINTS = [GspOneEndpoint, IrisEndpoint].freeze
  
        attr_accessor :environment
        def initialize(environment = ENVIRONMENTS.sandbox)
          self.environment = environment.to_sym
        end
  
        def make_request_with_endpoint(endpoint,
                                       clazz,
                                       set_base_url_proc,
                                       make_actual_call_proc)
          Rails.logger.info "Entering make_request_with_endpoint for #{clazz.gstin}"
          endpoint_instance = endpoint.new(environment)
          raise(::GstnAspException, 'Endpoint doesn\'t support environment') unless \
            endpoint_instance.matches
          set_base_url_proc.call(endpoint_instance.base_url)
          endpoint_instance.before_request clazz
          make_actual_call_proc.call(endpoint_instance.headers, endpoint)
        end
  
        def make_request(clazz, set_base_url_proc, make_actual_call_proc)
          Rails.logger.info "Entering make_request for #{clazz.gstin}"
          ORDERED_ENDPOINTS.each do |endpoint|
            Rails.logger.info "Trying Endpoint #{endpoint}"
            begin
              endpoint_instance = endpoint.new(environment)
              next unless endpoint_instance.matches
              set_base_url_proc.call(endpoint_instance.base_url)
              endpoint_instance.before_request clazz
              return make_actual_call_proc.call(endpoint_instance.headers, endpoint)
            rescue Net::ReadTimeout, Errno::ECONNREFUSED => error
              Prome.get(:aspone_gstn_fallbacks_total).increment(
                endpoint: endpoint.to_s
              )
              Rails.logger.error "Unable to connect to endpoint #{endpoint_instance}"
              Rails.logger.error error
            end
          end
          raise(::GstnAspException, 'No GSP Endpoints Available')
        end
      end
    end
  end
end
