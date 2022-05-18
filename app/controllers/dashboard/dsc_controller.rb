class Dashboard::DscController < Dashboard::SubscriptionActiveController

  authorize_resource class: false

  def register
    auth_header = helpers.current_react_token
    gstins = Gstin.accessible_by(current_ability)
    gstins_json = []
    gstins.map do |gstin|
      gstins_json.push({ text: "#{gstin.gstin_number}  (#{gstin.username})", key: gstin.id })
    end
    @props = {
      auth_header: auth_header,
      register_dsc_url: register_api_dsc_index_url,
      deregister_dsc_url: deregister_api_dsc_index_url,
      gstins: gstins_json
    }
  end

  def sign
    auth_header = helpers.current_react_token
    @props = {
      auth_header: auth_header
    }
  end



end
