class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :batch_code
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.integer :min_value
      t.integer :min_allowed_difference

      t.timestamps
    end
  end
end
