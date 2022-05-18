module RailsAdmin
  module Config
    module Actions
      class Export < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          proc do
            if params[:mail_address].present? && params[:from_date].present? && params[:to_date].present?
              @schema = HashHelper.symbolize(params[:schema].slice(:except, :include, :methods, :only).permit!.to_h) # to_json and to_xml expect symbols for keys AND values.
              @from_date = DateTime.strptime(params[:from_date], "%d/%m/%Y")
              @to_date = DateTime.strptime(params[:to_date], "%d/%m/%Y")
              email_address = params[:mail_address]
              UserMailer.delay.send_logs(@model_config.abstract_model, @schema, email_address, @from_date, @to_date)
              flash.now[:notice] = "Sent a mail successfully to #{email_address}. Be Patient"
              @action.template_name
            elsif format = params[:json] && :json || params[:csv] && :csv || params[:xml] && :xml 
              request.format = format
              @schema = HashHelper.symbolize(params[:schema].slice(:except, :include, :methods, :only).permit!.to_h) if params[:schema] # to_json and to_xml expect symbols for keys AND values.
              @objects = list_entries(@model_config, :export)
              index
            else
              render @action.template_name
            end
          end
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :link_icon do
          'icon-share'
        end
      end
    end
  end
end
