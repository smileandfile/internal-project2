class Dashboard::WorkingLevelController < Dashboard::SubscriptionActiveController
  before_action :check_working_level, except: [:level, :set] if CHECK_WORKING_LEVEL
  before_action :set_domain, only: [:level, :set]

  def check_working_level
    if current_user.present?
      redirect_to level_dashboard_domain_working_level_index_path(current_user&.domain) if current_user&.domain&.working_level.nil?
    end
  end

  def set
    new_hash = secure_domain_params.to_h
    wokring_level = new_hash[:working_level]
    @domain.working_level = wokring_level
    @domain.save
    respond_to do |format|
      if @domain.save
        format.html {return redirect_to dashboard_path, notice: "You have successfully selected working level"}
      else
        format.html { return render :level }
      end
    end
  end


  def level
  end
  private

  def set_domain
    @domain = Domain.find(params[:domain_id])
  end

  def secure_domain_params
    params.require(:domain).permit(:working_level)
  end


end
