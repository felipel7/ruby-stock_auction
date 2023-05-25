require "rails_helper"

describe "Admin bloqueia um usuário" do
  it "com sucesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit admin_profiles_path
    within(".table__controls form[action='/admin/profiles/#{user.id}/block']") do
      click_on "Bloquear"
    end

    expect(page).to have_content "CPF bloqueado com sucesso."
  end

  it "e o usuário não consegue mais fazer login" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit admin_profiles_path
    within(".table__controls form[action='/admin/profiles/#{user.id}/block']") do
      click_on "Bloquear"
    end
    within "aside" do
      click_on "Sair"
    end
    click_on "Entrar"
    fill_in "E-mail", with: user.email
    fill_in "Senha", with: user.password
    within ".actions" do
      click_on "Entrar"
    end

    expect(page).to have_content "A sua conta está suspensa, CPF foi bloqueado"
  end

  it "e o usuário não consegue mais criar uma conta com o CPF bloqueado" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")
    admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")

    login_as(admin)
    visit admin_profiles_path
    within(".table__controls form[action='/admin/profiles/#{user.id}/block']") do
      click_on "Bloquear"
    end
    within "aside" do
      click_on "Sair"
    end
    click_on "Entrar"
    click_on "Crie uma conta"
    fill_in "E-mail", with: "fernando@gmail.com.br"
    fill_in "CPF", with: user.cpf
    fill_in "Senha", with: user.password
    fill_in "Confirme sua senha", with: user.password
    within ".actions" do
      click_on "Criar conta"
    end

    expect(page).to have_content "CPF está bloqueado, entre em contato com o suporte."
  end
end
