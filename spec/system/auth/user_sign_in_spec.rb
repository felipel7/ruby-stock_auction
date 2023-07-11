require 'rails_helper'

describe 'Usuário regular faz login' do
  it 'com informações válidas' do
    User.create!(
      email: 'felipe@gmail.com',
      cpf: '64063418057',
      password: '123123'
    )

    visit root_path
    within 'header nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'Senha', with: '123123'
    within '.actions' do
      click_on 'Entrar'
    end

    within 'header nav' do
      expect(page).to have_content 'Felipe'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_button 'Entrar'
    end
    expect(page).to have_content 'Login efetuado com sucesso'
  end

  it 'com informações inválidas' do
    # Act
    visit root_path
    within 'header nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'Senha', with: '123123'
    within '.actions' do
      click_on 'Entrar'
    end

    # Assert
    within 'header nav' do
      expect(page).to have_button 'Entrar'
      expect(page).not_to have_button 'Sair'
    end
    expect(page).to have_content 'E-mail ou senha inválidos'
  end
end

describe 'Admin faz login' do
  it 'com informações válidas' do
    # Arrange
    user = User.create!(
      email: 'felipe@leilaodogalpao.com.br',
      cpf: '64063418057',
      password: '123123'
    )

    # Act
    visit root_path
    within 'header nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'felipe@leilaodogalpao.com.br'
    fill_in 'Senha', with: '123123'
    within '.actions' do
      click_on 'Entrar'
    end

    # Assert
    within 'header nav' do
      expect(page).to have_content 'Felipe'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_button 'Entrar'
    end
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(user.role).to include 'admin'
  end
end
