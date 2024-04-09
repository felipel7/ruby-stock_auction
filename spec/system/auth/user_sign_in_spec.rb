require 'rails_helper'

describe 'Usuário regular faz login' do
  it 'com informações válidas' do
    user = User.create!(
      first_name: 'felipe',
      last_name: 'silva',
      email: 'felipe@gmail.com',
      cpf: '64063418057',
      password: '123123'
    )

    visit root_path
    within 'aside' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).not_to have_content 'E-mail ou senha inválidos'
    within 'aside' do
      expect(page).to have_content 'Minha Conta'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_button 'Entrar'
    end
  end

  it 'com informações inválidas' do
    visit root_path
    within 'aside' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'Senha', with: '123123'
    click_on 'Entrar'

    expect(page).to have_content 'E-mail ou senha inválidos'
  end
end

describe 'Admin faz login' do
  it 'com informações válidas' do
    user = User.create!(
      first_name: 'felipe',
      last_name: 'silva',
      email: 'felipe@leilaodogalpao.com.br',
      cpf: '64063418057',
      password: '123123'
    )

    visit root_path
    within 'aside' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'

    expect(page).to have_content 'Minha Conta'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_button 'Entrar'
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(user.role).to include 'admin'
  end
end
