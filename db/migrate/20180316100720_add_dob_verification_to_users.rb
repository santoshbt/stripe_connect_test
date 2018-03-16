class AddDobVerificationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :dob_verification, :boolean, default: false
  end
end
