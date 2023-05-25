require "rails_helper"

describe "Usuário tenta registrar um novo produto" do
  it "e não tem acesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")

    login_as(user)
    visit new_admin_product_path

    expect(page).to have_content "Acesso negado. Você precisa ser um administrador para acessar esta página"
  end
end
