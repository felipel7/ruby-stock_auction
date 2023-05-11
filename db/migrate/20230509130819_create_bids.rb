class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
