class FixingDomainEntityBranchRelation < ActiveRecord::Migration[5.0]
  def change
    remove_reference :branches, :entity
    remove_reference :gstins, :domain
    add_reference :gstins, :entity, index: true
  end
end
