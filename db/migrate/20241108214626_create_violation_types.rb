class CreateViolationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :violation_types do |t|
      t.integer :class_code, null: false
      t.integer :risk, null: false
      t.text :description, null: false

      t.timestamps null: false
    end

    add_index :violation_types, [:class_code, :risk, :description], unique: true, name: :index_violation_types_on_unique_fields
  end
end