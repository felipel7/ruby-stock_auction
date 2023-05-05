class AddDefaultValueToStatusColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lots, :status, from: nil, to: 0
  end
end
