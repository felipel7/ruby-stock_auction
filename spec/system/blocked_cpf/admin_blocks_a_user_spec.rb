require 'rails_helper'

describe 'Admin bloqueia um usuário' do
  it 'com sucesso' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_dashboard_index_path
    within("#user") do
      click_on 'Gerenciar'
    end
    within("table form[action$='#{user.id}/block']") do
      click_on 'Bloquear'
    end

    expect(page).to have_content 'CPF bloqueado com sucesso.'
    expect(page).to have_content 'Bloqueado'
  end

  it 'e o usuário não consegue mais fazer login' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_dashboard_index_path
    within("#user") do
      click_on 'Gerenciar'
    end
    within("table form[action$='#{user.id}/block']") do
      click_on 'Bloquear'
    end
    within 'aside' do
      click_on 'Sair'
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'

    expect(page).to have_content 'A sua conta está suspensa, CPF foi bloqueado'
  end

  it 'e o usuário não consegue mais criar uma conta com o CPF bloqueado' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_dashboard_index_path
    within("#user") do
      click_on 'Gerenciar'
    end
    within("table form[action$='#{user.id}/block']") do
      click_on 'Bloquear'
    end
    within 'aside' do
      click_on 'Sair'
      click_on 'Entrar'
    end
    click_on 'Crie uma conta'
    fill_in 'Nome', with: user.first_name
    fill_in 'Sobrenome', with: user.last_name
    fill_in 'E-mail', with: 'fernando@gmail.com.br'
    fill_in 'CPF', with: user.cpf
    fill_in 'Senha', with: user.password
    fill_in 'Confirme sua senha', with: user.password
    click_on 'Criar conta'

    expect(page).not_to have_content 'Não foi possível salvar usuário: 7 erros'
    expect(page).to have_content 'CPF está bloqueado, entre em contato com o suporte.'
  end

  it 'e não consegue bloquear um usuário que já está bloqueado' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_dashboard_index_path
    within("#user") do
      click_on 'Gerenciar'
    end
    within("table form[action$='#{user.id}/block']") do
      click_on 'Bloquear'
      click_on 'Bloquear'
    end

    expect(page).to have_content 'CPF já está bloqueado.'
    expect(page).not_to have_content 'CPF bloqueado com sucesso.'
  end

  it 'e desbloqueia um usuário com sucesso' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_profiles_path
    within("table form[action$='#{user.id}/block']") do
      click_on 'Bloquear'
    end
    within("table form[action$='#{user.id}/unblock']") do
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'CPF foi desbloqueado com sucesso.'
    expect(page).not_to have_content 'CPF bloqueado com sucesso.'
  end

  it 'e não consegue desbloquear um usuário que não está bloqueado' do
    user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com.br', cpf: '81140180037', password: '123123')
    admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')

    login_as(admin)
    visit admin_profiles_path
    within("table form[action$='#{user.id}/unblock']") do
      click_on 'Desbloquear'
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'Não é possível desbloquear um CPF que não está bloqueado.'
    expect(page).not_to have_content 'CPF foi desbloqueado com sucesso.'
  end
end
