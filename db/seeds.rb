# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Categories

first_category = Category.create!(name: "Eletrônicos")
Category.create!(name: "Vestuário")
Category.create!(name: "Livros")
Category.create!(name: "Esportes")

ProductModel.create!(
  name: "Monitor LG",
  description: "Monitor de 24 polegadas da marca LG...",
  weight: 1500,
  width: 100,
  height: 80,
  depth: 15,
  category: first_category,
)
