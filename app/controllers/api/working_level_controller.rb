class Api::WorkingLevelController < Api::ApiController

  before_action :check_working_level, except: [:level, :set] if CHECK_WORKING_LEVEL

  def check_working_level
    if current_user&.domain&.working_level&.nil?
      msg = "Admin need to set working level first"
      render json: {msg: msg}, status: :failed_dependency
    end
  end

end
