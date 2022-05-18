require 'rails_admin/config/actions'  
require 'rails_admin/config/actions/base'

module RailsAdminSpecialDomainCreationAction; end

module RailsAdmin  
  module Actions
    class SpecialDomainCreation < RailsAdmin::Config::Actions::Base
      RailsAdmin::Config::Actions.register(self)

      register_instance_option :collection? do
        true
      end

      register_instance_option :route_fragment do
        'special_domain_creation'
      end

      register_instance_option :http_methods do
        %i(get post)
      end

      register_instance_option :visible? do
        bindings[:abstract_model].model.to_s == 'Domain'
      end

      register_instance_option :controller do
        proc do
          if request.get?
            render @action.template_name, layout: true # shows off your initial template code
          elsif request.post?
             @object.create(params[:domain])
            # all your code that does your work
            flash.now[:notice] = "Domain Successfully created."
            back_or_index
          end
        end
      end

      register_instance_option :link_icon do
        # font awesome icons. but an older version
        'icon-envelope' 
      end

    end
  end
end  