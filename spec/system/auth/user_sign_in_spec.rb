require "rails_helper"

describe "Usuário regular faz login" do
  it "com informações válidas" do
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
    fill_in "Password", with: "123123"
    within ".actions" do
      click_on "Entrar"
    end

    # Assert
    within "header nav" do
      expect(page).to have_content "felipe@gmail.com"
      expect(page).to have_button "Sair"
      expect(page).not_to have_button "Entrar"
    end
    expect(page).to have_content "Login efetuado com sucesso"
  end
end
