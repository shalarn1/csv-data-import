class CreateViolationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :violation_types do |t|
      t.integer :classification_code, null: false
      t.integer :risk_category, null: false
      t.text :description, null: false

      t.timestamps null: false
    end

    add_index :violation_types, [:classification_code, :risk_category, :description], unique: true, name: :index_violation_types_on_unique_fields
  end
end
