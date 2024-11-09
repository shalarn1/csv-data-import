class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|

      t.timestamps
    end
  end
end
