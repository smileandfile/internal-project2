class AddDomainToGstin < ActiveRecord::Migration[5.0]
  def change
    add_reference :gstins, :domain, index: true
  end
end
