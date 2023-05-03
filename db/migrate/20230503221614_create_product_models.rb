class CreateProductModels < ActiveRecord::Migration[7.0]
  def change
    create_table :product_models do |t|
      t.string :name
      t.text :description
      t.integer :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.string :sku
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
