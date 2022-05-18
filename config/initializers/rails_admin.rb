RailsAdmin::Config::Fields::Types::register(:citext, self)

# Allow for searching/filtering of `citext` fields.
module Adapters
  module ActiveRecord
    module CitextStatement
      private

      def build_statement_for_type
        if @type == :citext
          return build_statement_for_string_or_text
        else
          super
        end
      end
    end

    class StatementBuilder < RailsAdmin::AbstractModel::StatementBuilder
      prepend CitextStatement
    end
  end
end

RailsAdmin.config do |config|

  RailsAdmin::Config::Actions.register(
    RailsAdmin::Actions::OrderPayment
  )

  #excluded models
  config.excluded_models = ["EntitiesUser", "GstinsUser", "BranchesUser", "RolesUser"]

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  ## == Cancan ==
  config.authorize_with :cancan
  ## RailsAdmin is inheriting from ApplicationController
  ## if user is unauthorized and from there it get redirected to app root path.
  config.parent_controller = 'ApplicationController'
  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    order_payment

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
