require "rails_helper"

describe "Usuário procura através da barra de pesquisa" do
  it "e encontra o lote pelo nome do produto" do
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    category = Category.create!(name: "Eletrônicos")
    first_product = ProductModel.create!(
      name: "Monitor LG",
      description: "Monitor de 24 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: category,
    )
    second_product = ProductModel.create!(
      name: "Smartphone Samsung",
      description: "Smartphone Samsung s21...",
      weight: 1000,
      width: 100,
      height: 50,
      depth: 5,
      category: category,
    )
    first_lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 1200,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    second_lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 100,
      register_by_id: second_admin.id,
      approved_by_id: first_admin.id,
    )
    first_lot.product_models << first_product
    second_lot.product_models << second_product

    travel_to 1.hour.from_now do
      first_lot.update(status: :approved)
      second_lot.update(status: :approved)

      visit root_path
      fill_in "Buscar Produto", with: "Samsung"
      within ".search-bar__wrapper" do
        click_on "search"
      end

      expect(page).not_to have_content "Não há lotes em andamento no momento."
      expect(page).not_to have_content "R$ 1.200,00"
      expect(page).to have_content "R$ 2.500,00"
    end
  end
end
