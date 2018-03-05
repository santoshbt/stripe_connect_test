class CreateProofs < ActiveRecord::Migration[5.0]
  def change
    create_table :proofs do |t|
      t.string :purpose
      t.string :file

      t.timestamps
    end
  end
end
