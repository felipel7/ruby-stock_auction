require "rails_helper"

describe "Usuário da um novo lance" do
  it "e falha quando o valor do lance é mais baixo que o mínimo permitido" do
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    user = User.create!(email: "felipe@gmail.com", cpf: "70587229004", password: "123123")
    lot = Lot.create!(
      start_date: 1.second.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    lot.update(start_date: 1.minute.ago)

    login_as(user)
    visit root_path
    within "nav" do
      click_on "Lotes"
    end
    fill_in "Amount", with: 30
    click_on "Dar Lance"

    expect(page).to have_content "Não foi possível dar o lance"
    expect(page).to have_content "Valor deve ser maior que o mínimo permitido para cada lance"
  end

  it "e falha quando o lote ainda não está em andamento" do
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    user = User.create!(email: "felipe@gmail.com", cpf: "70587229004", password: "123123")
    category = Category.create!(name: "Eletrônicos")
    product = ProductModel.create!(
      name: "Monitor LG",
      description: "Monitor de 24 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: category,
    )
    lot = Lot.create!(
      start_date: 1.hour.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    lot.product_models << product
    lot.update(status: :approved)

    login_as(user)
    visit root_path
    within "nav" do
      click_on "Lotes"
    end
    fill_in "Amount", with: 40
    click_on "Dar Lance"

    expect(page).to have_content "Não foi possível dar o lance"
    expect(page).to have_content "Um lance não pode ser dado em um lote que não está em andamento"
  end

  it "com sucesso" do
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    user = User.create!(email: "felipe@gmail.com", cpf: "70587229004", password: "123123")
    category = Category.create!(name: "Eletrônicos")
    product = ProductModel.create!(
      name: "Monitor LG",
      description: "Monitor de 24 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: category,
    )
    lot = Lot.create!(
      start_date: 1.second.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    lot.product_models << product
    lot.update(status: :approved)
    lot.update(start_date: 1.minute.ago)

    login_as(user)
    visit root_path
    within "nav" do
      click_on "Lotes"
    end
    fill_in "Amount", with: 50
    click_on "Dar Lance"

    expect(page).to have_content "O lance foi atualizado com sucesso."
    expect(page).to have_content "Lance atual: 2550"
  end
end
