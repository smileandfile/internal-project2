class Gstr1Controller < ApplicationController
  layout "react-form-layout"
  before_action :authenticate_user!

  def index
    @hello_world_props = { name: "Stranger" }
  end

  def save_invoices
    @hello_world_props = { name: "Stranger",
                           auth_header: @@new_auth_header }
  end

  def file_gstr1
    @hello_world_props = { name: "Stranger",
                           auth_header: @@new_auth_header }
  end

  def submit_gstr1
    @hello_world_props = { name: "Stranger",
                           auth_header: @@new_auth_header }
  end

  def users
    @hello_world_props = {
      users: User.all.map{ |u| u.to_builder.attributes! },
      gstins_by_entities: Gstin.all.to_a.group_by(&:entity_id),
      entities: Entity.all,
      auth_header: @@new_auth_header
    }
    # these should be accessible by and not all
  end

  protected
  
  def authenticate_user!
    if user_signed_in?
      @@new_auth_header = helpers.current_react_token
      # if session[:current_gstin].nil?
      #   redirect_to dashboard_path, notice: 'choose your gstin'
      # end

      @@new_auth_header['gstin-id'] = session[:current_gstin]
      super
    else
      redirect_to new_user_session_path
    end
  end

end
