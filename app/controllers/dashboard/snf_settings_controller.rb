class Dashboard::SnfSettingsController < Dashboard::BaseDashboardController
  before_action :set_snf_setting
  load_and_authorize_resource

  
  def update
    respond_to do |format|
      if @snf_setting.update(snf_setting_params)
        format.html { redirect_to dashboard_path, notice: "Updated successfully."}
      else
        format.html { render :edit}
        format.json { render json: @@snf_setting, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def edit
  end

  def update_gstin_token_nil
    respond_to do |format|
      Gstin.update_all({auth_token: nil, auth_expires_at: nil, auth_token_expires_at: nil, server_time: nil, actual_time_of_token_expires: nil})
      format.html { redirect_to reset_token_dashboard_snf_settings_path, notice: "GSTIN Auth token ppdated successfully."}
    end
  end

  def update_eway_token_nil
    respond_to do |format|
      EwayBillMultipleAuth.update_all({auth_token: nil, auth_token_expires_at: nil, auth_encrypted_sek: nil,auth_decrypted_sek: nil, app_key: nil })
      format.html { redirect_to reset_token_dashboard_snf_settings_path, notice: "Eway Auth token ppdated successfully."}
    end
  end
  def update_common_token_nil
    respond_to do |format|
      CommonApiAuth.update_all({auth_token: nil, auth_token_expires_at: nil})
      format.html { redirect_to reset_token_dashboard_snf_settings_path, notice: "Common Api Auth token ppdated successfully."}
    end
  end

  def reset_token
  end

  private

  def set_snf_setting
    @snf_setting = SnfSetting.first
  end

  def snf_setting_params
    params.require(:snf_setting).permit(:whats_new, :faqs, :gstin_number)
  end

end