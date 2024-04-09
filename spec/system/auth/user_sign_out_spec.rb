require 'rails_helper'

describe 'Usuário tenta fazer o logout' do
  it 'e sai da aplicação' do
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

    within 'aside' do
      click_on 'Sair'
    end

    expect(page).to have_content 'Logout efetuado com sucesso'
    within 'aside' do
      expect(page).to have_content 'Entrar'
      expect(page).not_to have_content 'Sair'
    end
  end
end
