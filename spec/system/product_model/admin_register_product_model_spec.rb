require "rails_helper"

describe "Admin registra um novo produto" do
  it "e envia com sucesso" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "00000000000", password: "123123")
    Category.create!(name: "Vestuário")
    Category.create!(name: "Eletrônicos")

    login_as(admin)
    visit root_path
    click_on "Produtos"
    click_on "Cadastrar Novo Produto"
    fill_in "Nome", with: "Monitor LG"
    fill_in "Descrição", with: "Monitor de 24 polegadas da marca LG..."
    fill_in "Altura", with: 80
    fill_in "Largura", with: 100
    fill_in "Profundidade", with: 10
    fill_in "Peso", with: 15
    select "Eletrônicos", from: "Categoria"
    click_on "Criar Produto"

    expect(page).to have_content "O produto foi cadastrado com sucesso"
    expect(page).to have_content "Monitor LG"
    expect(page).to have_content "Dimensões: 100cm x 80cm x 10cm"
    expect(page).to have_content "Categoria: Eletrônicos"
    expect(page).not_to have_content "Vestuário"
  end
end

describe "Usuário tenta registrar um novo produto" do
  it "e não tem acesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")

    login_as(user)
    visit product_models_path

    expect(page).to have_content "Acesso negado. Você precisa ser um administrador para acessar esta página"
  end
end
