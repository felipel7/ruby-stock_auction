require "rails_helper"

describe "Admin registra um novo lote" do
  it "com sucesso" do
    admin = User.create!(
      email: "maria@leilaodogalpao.com.br",
      cpf: "03507869098",
      password: "123123",
    )

    allow(SecureRandom).to receive(:random_number).and_return("123456")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Cadastrar Novo Lote"
    day = 1.day.from_now.day.to_s
    month = I18n.l(1.day.from_now, format: "%B")
    year = 1.day.from_now.year.to_s
    select(day, from: "lot_start_date_3i")
    select(month, from: "lot_start_date_2i")
    select(year, from: "lot_start_date_1i")
    select("23", from: "lot_start_date_4i")
    select("57", from: "lot_start_date_5i")
    select(day, from: "lot_end_date_3i")
    select(month, from: "lot_end_date_2i")
    select(year, from: "lot_end_date_1i")
    select("23", from: "lot_end_date_4i")
    select("59", from: "lot_end_date_5i")
    fill_in "Valor mínimo", with: 100
    fill_in "Valor mínimo da diferença", with: 10
    click_on "Cadastrar Novo Lote"

    expect(page).not_to have_content "Não foi possível cadastrar o lote"
    expect(page).to have_content "123456"
    expect(page).to have_content "Criador por: Maria"
  end

  it "e falha quando tem informações incorretas" do
    admin = User.create!(
      email: "maria@leilaodogalpao.com.br",
      cpf: "03507869098",
      password: "123123",
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Cadastrar Novo Lote"
    day = 1.day.from_now.day.to_s
    month = I18n.l(1.day.from_now, format: "%B")
    year = 1.day.from_now.year.to_s
    select(day, from: "lot_start_date_3i")
    select(month, from: "lot_start_date_2i")
    select(year, from: "lot_start_date_1i")
    select("23", from: "lot_start_date_4i")
    select("57", from: "lot_start_date_5i")
    select(day, from: "lot_end_date_3i")
    select(month, from: "lot_end_date_2i")
    select(year, from: "lot_end_date_1i")
    select("23", from: "lot_end_date_4i")
    select("59", from: "lot_end_date_5i")
    fill_in "Valor mínimo", with: 0
    fill_in "Valor mínimo da diferença", with: -10
    click_on "Cadastrar Novo Lote"

    expect(page).to have_content "Não foi possível cadastrar o lote"
    expect(page).to have_content "Valor mínimo deve ser maior que 0"
    expect(page).to have_content "Valor mínimo da diferença deve ser maior que 0"
  end
end
