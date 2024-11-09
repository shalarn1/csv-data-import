class CreateViolationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :violation_types do |t|

      t.timestamps
    end
  end
end
