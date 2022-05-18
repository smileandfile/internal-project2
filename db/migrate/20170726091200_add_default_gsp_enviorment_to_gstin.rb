class AddDefaultGspEnviormentToGstin < ActiveRecord::Migration[5.0]
  def up
    Gstin.where(gsp_environment: nil).update_all(gsp_environment: :preprod) if Gstin.present?
  end
end
