DeviseTokenAuth.setup do |config|
  # By default the authorization headers will change after each request. The
  # client is responsible for keeping track of the changing tokens. Change
  # this to false to prevent the Authorization header from changing after
  # each request.
  config.change_headers_on_each_request = false

  # By default, users will need to re-authenticate after 2 weeks. This setting
  # determines how long tokens will remain valid after they are issued.
  # config.token_lifespan = 2.weeks

  # Sets the max number of concurrent devices per user, which is 10 by default.
  # After this limit is reached, the oldest tokens will be removed.
  # config.max_number_of_devices = 10

  # Sometimes it's necessary to make several requests to the API at the same
  # time. In this case, each request in the batch will need to share the same
  # auth token. This setting determines how far apart the requests can be while
  # still using the same auth token.
  # config.batch_request_buffer_throttle = 5.seconds

  # This route will be the prefix for all oauth2 redirect callbacks. For
  # example, using the default '/omniauth', the github oauth2 provider will
  # redirect successful authentications to '/omniauth/github/callback'
  # config.omniauth_prefix = "/omniauth"

  # By default sending current password is not needed for the password update.
  # Uncomment to enforce current_password param to be checked before all
  # attribute updates. Set it to :password if you want it to be checked only if
  # password is updated.
  # config.check_current_password_before_update = :attributes

  # By default we will use callbacks for single omniauth.
  # It depends on fields like email, provider and uid.
  config.default_callbacks = false

  # Makes it possible to change the headers names
  # config.headers_names = {:'access-token' => 'access-token',
  #                        :'client' => 'client',
  #                        :'expiry' => 'expiry',
  #                        :'uid' => 'uid',
  #                        :'token-type' => 'token-type' }

  # By default, only Bearer Token authentication is implemented out of the box.
  # If, however, you wish to integrate with legacy Devise authentication, you can
  # do so by enabling this flag. NOTE: This feature is highly experimental!
  # config.enable_standard_devise_support = false
  config.default_confirm_success_url = "confirmed"
  config.default_password_reset_url = "password"

end

# required to wrap in to_prepare to make it work with auto-reload in dev
Rails.configuration.to_prepare do
  # added domain name in headers while searching for user authentication (domain name + email)
  DeviseTokenAuth::Concerns::SetUserByToken.class_eval do
      # user auth
    def set_user_by_token(mapping=nil)
      # determine target authentication class
      rc = resource_class(mapping)

      # no default user defined
      return unless rc

      #gets the headers names, which was set in the initialize file
      uid_name = DeviseTokenAuth.headers_names[:'uid']
      access_token_name = DeviseTokenAuth.headers_names[:'access-token']
      client_name = DeviseTokenAuth.headers_names[:'client']

      # parse header for values necessary for authentication
      uid        = request.headers[uid_name] || params[uid_name]
      domain_name = request.headers['domain-name'] || params['domain-name']
      @token     ||= request.headers[access_token_name] || params[access_token_name]
      @client_id ||= request.headers[client_name] || params[client_name]

      # client_id isn't required, set to 'default' if absent
      @client_id ||= 'default'

      # check for an existing user, authenticated via warden/devise, if enabled
      if DeviseTokenAuth.enable_standard_devise_support
        devise_warden_user = warden.user(rc.to_s.underscore.to_sym)
        if devise_warden_user && devise_warden_user.tokens[@client_id].nil?
          @used_auth_by_token = false
          @resource = devise_warden_user
          @resource.create_new_auth_token
        end
      end

      # user has already been found and authenticated
      return @resource if @resource && @resource.class == rc

      # ensure we clear the client_id
      if !@token
        @client_id = nil
        return
      end

      return false unless @token

      # mitigate timing attacks by finding by uid instead of auth token
      # searching user on basis of its email + domain-name
      user = uid && rc.find_for_authentication({email: uid, domain_name: domain_name})
      if user && user.valid_token?(@token, @client_id)
        # sign_in with bypass: true will be deprecated in the next version of Devise
        if self.respond_to? :bypass_sign_in
          bypass_sign_in(user, scope: :user)
        else
          sign_in(:user, user, store: false, bypass: true)
        end
        return @resource = user
      else
        # zero all values previously set values
        @client_id = nil
        return @resource = nil
      end
    end

  end
end
