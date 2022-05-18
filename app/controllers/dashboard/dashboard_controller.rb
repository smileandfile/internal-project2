class Dashboard::DashboardController < Dashboard::WorkingLevelController

  skip_before_action :check_email_verified, only: [:index, :api_tester]

  skip_before_action :authenticate_user!, only: [:api_tester]
  skip_before_action :check_phone_verified, only: [:api_tester]
  skip_before_action :check_subcription_active, only: [:api_tester]


  def index
  end

  def api_tester
    @props = {}
  end


end
