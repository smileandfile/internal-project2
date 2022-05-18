require "json-schema"
class Dashboard::PublicApisController < Dashboard::SubscriptionActiveController

  def search_taxpayer
    auth_header = helpers.current_react_token
    @props = {
       auth_header: auth_header,
       search_tax_payer_url: search_taxpayer_api_public_apis_url
    }
  end
  
end
