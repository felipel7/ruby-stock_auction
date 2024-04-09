require 'rails_helper'

describe 'A página de lances é acessa pelo' do
  context 'usuário' do
    it 'e retorna todos os seus lances' do
      first_admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')
      second_admin = User.create!(first_name: 'felipe', last_name: 'silva',email: 'felipe@leilaodogalpao.com.br', cpf: '14367226085', password: '123123')
      user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com', cpf: '70587229004', password: '123123')
      category = Category.create!(name: 'Eletrônicos')
      product = Product.create!(
        name: 'Monitor LG',
        description: 'Monitor de 24 polegadas da marca LG...',
        weight: 1500,
        width: 100,
        height: 80,
        depth: 15,
        category:
      )
      lot = Lot.create!(
        batch_code: 'EOR661430',
        start_date: 1.second.from_now,
        end_date: 1.day.from_now,
        min_value: 2500,
        min_allowed_difference: 35,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id
      )
      lot.products << product
      lot.approved!

      travel_to 1.hour.from_now do
        login_as(user)
        visit root_path
        within 'aside' do
          click_on 'Lotes'
        end
        click_on 'Dar Lance'
        fill_in 'bid-input', with: 50
        click_on 'Dar Lance'
        within 'aside' do
          click_on 'Lances'
        end

        within(:css, 'section:has(h2:contains("Meus lances vencedores"))') do
          expect(page).to have_content 'Lote: EOR661430'
          expect(page).to have_content 'R$ 2.500,00'
        end

        within(:css, 'section:has(h2:contains("Meu histórico de lances"))') do
          expect(page).to have_content 'Lote: EOR661430'
          expect(page).to have_content 'R$ 2.500,00'
        end
      end
    end
  end

  context 'admin' do
    it 'e retorna o lance de todos os usuários' do
      first_admin = User.create!(first_name: 'maria', last_name: 'silva',email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')
      second_admin = User.create!(first_name: 'felipe', last_name: 'silva',email: 'felipe@leilaodogalpao.com.br', cpf: '14367226085', password: '123123')
      first_user = User.create!(first_name: 'felipe', last_name: 'silva',email: 'felipe@gmail.com', cpf: '70587229004', password: '123123')
      second_user = User.create!(first_name: 'maria', last_name: 'silva',email: 'maria@gmail.com', cpf: '48092119082', password: '123123')
      category = Category.create!(name: 'Eletrônicos')
      product = Product.create!(
        name: 'Monitor LG',
        description: 'Monitor de 24 polegadas da marca LG...',
        weight: 1500,
        width: 100,
        height: 80,
        depth: 15,
        category:
      )
      lot = Lot.create!(
        batch_code: 'EOR661430',
        start_date: 1.second.from_now,
        end_date: 1.day.from_now,
        min_value: 2500,
        min_allowed_difference: 35,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id
      )
      lot.products << product
      lot.approved!

      travel_to 1.hour.from_now do
        Bid.create!(user: first_user, lot:, amount: 45)
        Bid.create!(user: second_user, lot:, amount: 50)

        login_as(first_admin)
        visit root_path
        within 'aside' do
          click_on 'Lances'
        end

        expect(page).to have_content 'EOR661430'
        expect(page).to have_content 'felipe@gmail.com'
        expect(page).to have_content '45'
        expect(page).to have_content 'maria@gmail.com'
        expect(page).to have_content '50'
      end
    end
  end
end
