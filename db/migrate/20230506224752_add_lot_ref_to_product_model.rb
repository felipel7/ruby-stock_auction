class AddLotRefToProductModel < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_models, :lot, foreign_key: true
  end
end
