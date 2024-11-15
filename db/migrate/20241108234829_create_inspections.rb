class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.integer :score
      t.date :occurred_on, null: false
      t.integer :category, null: false

      t.references :restaurant, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :inspections, [:restaurant_id, :occurred_on, :category], unique: true,
                                                                       name: :index_inspections_on_search_fields
  end
end
