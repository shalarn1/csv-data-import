class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :phone_number, limit: 15
      t.references :address, foreign_key: true, null: false
      t.references :owner, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :restaurants, [:name, :address_id], unique: true
  end
end
