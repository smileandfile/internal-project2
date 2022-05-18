class AddEntiityReferenceInBranch < ActiveRecord::Migration[5.0]
  def change
    add_reference :branches, :entity, index: true
  end
end
