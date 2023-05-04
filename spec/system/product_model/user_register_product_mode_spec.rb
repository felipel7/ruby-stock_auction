require "rails_helper"

describe "Admin registra um novo produto" do
  it "e envia com sucesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "00000000000", password: "123123")

    login_as(user)
    visit root_path
    click_on "Produtos"

    expect(page).to have_content "Acesso negado. Você precisa ser um administrador para acessar esta página"
  end
end
