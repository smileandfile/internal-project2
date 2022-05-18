require 'rails_admin/config/actions'  
require 'rails_admin/config/actions/base'

module RailsAdminOrderPaymentAction; end

module RailsAdmin  
  module Actions
    class OrderPayment < RailsAdmin::Config::Actions::Base
      RailsAdmin::Config::Actions.register(self)

      register_instance_option :member? do
        true
      end

      register_instance_option :route_fragment do
        'order_payment'
      end

      register_instance_option :http_methods do
        %i(get put patch)
      end

      register_instance_option :visible? do
        bindings[:abstract_model].model.to_s == 'Order'
      end

      register_instance_option :controller do
        proc do
          if request.get?
            render @action.template_name, layout: true # shows off your initial template code
          elsif request.put?
             @object.update(params[:order].as_json)
            # all your code that does your work
            flash.now[:notice] = "Order payment details update successful"
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