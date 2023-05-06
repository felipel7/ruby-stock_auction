class AddForeignKeysToLot < ActiveRecord::Migration[7.0]
  def change
    add_reference :lots, :register_by, foreign_key: { to_table: :users }
    add_reference :lots, :approved_by, foreign_key: { to_table: :users }
  end
end
