require 'rails_helper'

describe 'Admin registra um novo lote' do
  it 'com sucesso' do
    admin = User.create!(
      first_name: 'maria', last_name: 'silva',
      email: 'maria@leilaodogalpao.com.br',
      cpf: '03507869098',
      password: '123123'
    )

    login_as(admin)
    visit root_path
    within 'aside' do
      click_on 'Dashboard'
    end
    within '#lot' do
      click_on 'Gerenciar'
    end
    click_on 'Cadastrar Novo Lote'
    fill_in 'Código do Lote', with: 'KAO668595'
    fill_in 'Data de início', with: 1.hour.from_now
    fill_in 'Data de encerramento', with: 1.day.from_now
    fill_in 'Valor mínimo inicial', with: 100
    fill_in 'Valor mínimo do lance', with: 10
    click_on 'Criar Lote'

    expect(page).not_to have_content 'Não foi possível cadastrar o lote'
    expect(page).to have_content 'KAO668595'
    expect(page).to have_content 'Criado por: Maria'
  end

  it 'e falha quando tem informações incorretas' do
    admin = User.create!(
      first_name: 'maria', last_name: 'silva',
      email: 'maria@leilaodogalpao.com.br',
      cpf: '03507869098',
      password: '123123'
    )

    login_as(admin)
    visit root_path
    within 'aside' do
      click_on 'Dashboard'
    end
    within '#lot' do
      click_on 'Gerenciar'
    end
    click_on 'Cadastrar Novo Lote'
    fill_in 'Data de início', with: 1.hour.ago
    fill_in 'Data de encerramento', with: 1.day.ago
    fill_in 'Valor mínimo inicial', with: 0
    fill_in 'Valor mínimo do lance', with: -10
    click_on 'Criar Lote'

    expect(page).to have_content 'Não foi possível cadastrar o lote'
    expect(page).to have_content 'Código do Lote não pode ficar em branco'
    expect(page).to have_content 'Valor mínimo inicial deve ser maior que 0'
    expect(page).to have_content 'Valor mínimo do lance deve ser maior que 0'
    expect(page).to have_content 'Data de início deve ser posterior à hora atual'
    expect(page).to have_content 'Data de encerramento deve ser posterior à data de início'
  end

  it 'e edita com sucesso' do
    admin = User.create!(
      first_name: 'maria', last_name: 'silva',
      email: 'maria@leilaodogalpao.com.br',
      cpf: '03507869098',
      password: '123123'
    )
    lot = Lot.create!(
      batch_code: 'LMP654321',
      start_date: 1.day.from_now,
      end_date: 2.days.from_now,
      min_value: 500,
      min_allowed_difference: 5,
      register_by_id: admin.id
    )

    login_as(admin)
    visit root_path
    within 'aside' do
      click_on 'Dashboard'
    end
    within '#lot' do
      click_on 'Gerenciar'
    end
    click_on 'Editar'
    fill_in 'Código do Lote', with: 'XYZ123123'
    fill_in 'Valor mínimo do lance', with: 20
    click_on 'Atualizar Lote'

    expect(page).to have_content 'O lote foi atualizado com sucesso.'
    expect(page).to have_content 'Lote: XYZ123123'
    expect(lot.reload.min_allowed_difference).to be 20
    expect(page).not_to have_content 'Lote: LMP654321'
  end

  it 'e edita, mas falha com dados incorretos' do
    admin = User.create!(
      first_name: 'maria', last_name: 'silva',
      email: 'maria@leilaodogalpao.com.br',
      cpf: '03507869098',
      password: '123123'
    )
    Lot.create!(
      batch_code: 'LMP654321',
      start_date: 1.day.from_now,
      end_date: 2.days.from_now,
      min_value: 500,
      min_allowed_difference: 5,
      register_by_id: admin.id
    )

    login_as(admin)
    visit root_path
    within 'aside' do
      click_on 'Dashboard'
    end
    within '#lot' do
      click_on 'Gerenciar'
    end
    click_on 'Editar'
    fill_in 'Código do Lote', with: 'AC'
    fill_in 'Data de início', with: 1.hour.ago
    fill_in 'Data de encerramento', with: 1.day.ago
    fill_in 'Valor mínimo do lance', with: -20
    click_on 'Atualizar Lote'

    expect(page).to have_content 'Não foi possível atualizar o lote'
    expect(page).to have_content 'Valor mínimo do lance deve ser maior que 0'
    expect(page).to have_content 'Data de início deve ser posterior à hora atual'
    expect(page).to have_content 'Data de encerramento deve ser posterior à data de início'
    expect(page).to have_content 'Código do Lote deve ter 9 caracteres'
  end
end
