class CreateViolations < ActiveRecord::Migration[7.0]
  def change
    create_table :violations do |t|
      t.date :occurred_on, null: false
      t.references :violation_type, foreign_key: true, null: false
      t.references :inspection, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
