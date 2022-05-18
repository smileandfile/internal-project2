class RemoveEntityReferneceFromGstin < ActiveRecord::Migration[5.0]
  def change
    remove_reference :gstins, :entity, index: true
  end
end
