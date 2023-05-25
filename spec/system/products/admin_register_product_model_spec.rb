require "rails_helper"

describe "Admin registra um novo produto" do
  it "e envia com sucesso" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    Category.create!(name: "Vestuário")
    Category.create!(name: "Eletrônicos")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Produtos"
    end
    click_on "Cadastrar Novo Produto"
    fill_in "Nome", with: "Monitor LG"
    fill_in "Descrição", with: "Monitor de 24 polegadas da marca LG..."
    fill_in "Altura", with: 80
    fill_in "Largura", with: 100
    fill_in "Profundidade", with: 10
    fill_in "Peso", with: 1500
    select "Eletrônicos", from: "Categoria"
    click_on "Salvar Produto"

    expect(page).to have_content "O produto foi cadastrado com sucesso"
    expect(page).to have_content "Monitor LG"
    expect(page).to have_content "Dimensões: 100cm x 80cm x 10cm"
    expect(page).to have_content "Categoria: Eletrônicos"
    expect(page).not_to have_content "Vestuário"
  end

  it "e edita com sucesso" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    first_category = Category.create!(name: "Vestuário")
    second_category = Category.create!(name: "Eletrônicos")

    allow(SecureRandom).to receive(:alphanumeric).and_return("GZEGINJIOI")

    product = Product.create!(
      name: "Monitor LG",
      description: "Monitor de 32 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: first_category,
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Produtos"
    end
    click_on "GZEGINJIOI"
    click_on "Editar"
    fill_in "Nome", with: "Monitor Dell"
    fill_in "Descrição", with: "Monitor de 32 polegadas da marca Dell..."
    click_on "Salvar Produto"

    expect(page).to have_content "O Produto foi salvo com sucesso."
    expect(page).to have_content "Produto - Monitor Dell"
    expect(page).to have_content "Descrição: Monitor de 32 polegadas da marca Dell"
    expect(page).not_to have_content "Monitor LG"
  end

  it "e falha quando tem informações incorretas" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    Category.create!(name: "Vestuário")
    Category.create!(name: "Eletrônicos")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Produtos"
    end
    click_on "Cadastrar Novo Produto"
    fill_in "Nome", with: "Monitor LG"
    fill_in "Descrição", with: ""
    fill_in "Altura", with: -80
    fill_in "Largura", with: 0
    fill_in "Profundidade", with: -10
    fill_in "Peso", with: -15
    select "Eletrônicos", from: "Categoria"
    click_on "Salvar Produto"

    expect(page).to have_content "Não foi possível cadastrar o produto"
    expect(page).to have_content "Descrição não pode ficar em branco"
    expect(page).to have_content "Peso deve ser maior que 0"
    expect(page).to have_content "Largura deve ser maior que 0"
    expect(page).to have_content "Altura deve ser maior que 0"
    expect(page).to have_content "Profundidade deve ser maior que 0"
  end
end
