class AddPersonalIdNumberToProof < ActiveRecord::Migration[5.0]
  def change
    add_column :proofs, :personal_id_number, :string, unique: true
  end
end
