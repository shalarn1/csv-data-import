class CreateOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false
      t.references :address, foreign_key: true

      t.timestamps null: false
    end

    add_index :owners, [:name, :address_id], unique: true
  end
end
