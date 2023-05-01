require "rails_helper"

describe "Usuário tenta fazer o logout" do
  it "e sai da aplicação" do
    # Arrange
    user = User.create!(
      email: "felipe@gmail.com",
      cpf: "11111111111",
      password: "123123",
    )

    # Act
    visit root_path
    within "header nav" do
      click_on "Entrar"
    end
    fill_in "E-mail", with: "felipe@gmail.com"
    fill_in "Senha", with: "123123"
    within ".actions" do
      click_on "Entrar"
    end
    within "header nav" do
      click_on "Sair"
    end

    # Assert
    within "header nav" do
      expect(page).to have_button "Entrar"
      expect(page).not_to have_button "Sair"
    end
    expect(page).to have_content "Logout efetuado com sucesso"
  end
end
