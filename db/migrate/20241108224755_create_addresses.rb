class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :state
      t.string :postal_code, null: false
      t.string :country, default: 'US'

      t.timestamps null: false
    end

    add_index :addresses, [:street, :postal_code], unique: true
  end
end
