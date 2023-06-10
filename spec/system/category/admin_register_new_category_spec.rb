require "rails_helper"

describe "Admin registra uma nova categoria" do
  it "com sucesso" do
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Categorias"
    end
    click_on "Cadastrar Nova Categoria"
    fill_in "Nome", with: "Eletrônicos"
    click_on "Criar nova Categoria"

    expect(current_path).to eq admin_categories_path
    expect(page).to have_content "Categoria salva com sucesso"
    expect(page).to have_content "Eletrônicos"
  end

  it "e falha quando não fornece um nome" do
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Categorias"
    end
    click_on "Cadastrar Nova Categoria"
    fill_in "Nome", with: ""
    click_on "Criar nova Categoria"

    expect(page).to have_content "Não foi possível salvar a categoria"
    expect(page).to have_content "Nome não pode ficar em branco"
    expect(page).not_to have_content "Eletrônicos"
  end

  it "e edita uma categoria com sucesso" do
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Categorias"
    end
    click_on "Cadastrar Nova Categoria"
    fill_in "Nome", with: "Eletrônico"
    click_on "Criar nova Categoria"
    click_on "Editar"
    fill_in "Nome", with: "Eletrônicos"
    click_on "Editar Categoria"

    expect(page).to have_content "Categoria foi atualizada com sucesso"
    expect(page).to have_content "Eletrônicos"
  end

  it "e não consegue editar uma categoria sem fornecer um nome" do
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Categorias"
    end
    click_on "Cadastrar Nova Categoria"
    fill_in "Nome", with: "Eletrônico"
    click_on "Criar nova Categoria"
    click_on "Editar"
    fill_in "Nome", with: ""
    click_on "Editar Categoria"

    expect(page).not_to have_content "Categoria foi atualizada com sucesso"
    expect(page).to have_content "Não foi possível editar a categoria."
    expect(page).to have_content "Nome não pode ficar em branco"
  end
end
