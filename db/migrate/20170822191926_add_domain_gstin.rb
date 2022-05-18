class AddDomainGstin < ActiveRecord::Migration[5.0]
  def change
    add_reference :gstins, :domain
  end
end
