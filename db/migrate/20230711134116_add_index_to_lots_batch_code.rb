class AddIndexToLotsBatchCode < ActiveRecord::Migration[7.0]
  def change
    add_index :lots, :batch_code
  end
end
