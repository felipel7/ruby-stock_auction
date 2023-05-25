class RenameProductModelsToProducts < ActiveRecord::Migration[7.0]
  def change
    rename_table :product_models, :products
  end
end
