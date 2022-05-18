class UpdateDomainGstins < ActiveRecord::Migration[5.0]
  def change
    gstins = Gstin.where(domain: nil)
    gstins.each do |gstin|
      gstin.domain = gstin.entity.domain if gstin.entity.present?
      gstin.save
    end
  end
end
