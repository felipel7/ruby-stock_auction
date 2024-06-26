require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe '#valid?' do
    it 'Não pode existir um lance sem valor' do
      bid = Bid.new

      bid.valid?

      expect(bid.errors.full_messages).to include 'Valor não pode ficar em branco'
    end

    it 'Valor do lance precisa ser maior que o mínimo permitido' do
      admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')
      user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com', cpf: '70587229004', password: '123123')
      lot = Lot.create!(
        batch_code: 'EOR661430',
        start_date: 1.day.from_now,
        end_date: 8.days.from_now,
        min_value: 2500,
        min_allowed_difference: 35,
        register_by_id: admin.id,
        approved_by_id: 2
      )

      bid = Bid.new(user:, lot:, amount: 34)
      bid.valid?

      expect(bid.errors.full_messages).to include 'O valor deve ser maior que o mínimo permitido para cada lance.'
    end

    it 'Não deve ser possível dar lance em um lote que ainda não foi iniciado' do
      first_admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')
      second_admin = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@leilaodogalpao.com.br', cpf: '14367226085', password: '123123')
      user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com', cpf: '70587229004', password: '123123')
      lot = Lot.create!(
        batch_code: 'EOR661430',
        start_date: 1.hour.from_now,
        end_date: 2.days.from_now,
        min_value: 2500,
        min_allowed_difference: 35,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id
      )
      category = Category.create!(name: 'Eletrônicos')
      product = Product.create!(
        name: 'Monitor LG',
        description: 'Monitor de 32 polegadas da marca LG...',
        weight: 1500,
        width: 100,
        height: 80,
        depth: 15,
        category:
      )
      lot.products << product
      lot.approved!

      bid = Bid.new(user:, lot:, amount: 35)
      bid.valid?

      expect(bid.errors.full_messages).to include 'Um lance não pode ser dado em um lote que não está em andamento.'
    end

    it 'Não deve ser possível dar lance em um lote que já foi encerrado' do
      first_admin = User.create!(first_name: 'maria', last_name: 'silva', email: 'maria@leilaodogalpao.com.br', cpf: '03507869098', password: '123123')
      second_admin = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@leilaodogalpao.com.br', cpf: '14367226085', password: '123123')
      user = User.create!(first_name: 'felipe', last_name: 'silva', email: 'felipe@gmail.com', cpf: '70587229004', password: '123123')
      lot = Lot.create!(
        batch_code: 'EOR661430',
        start_date: 1.hour.from_now,
        end_date: 1.day.from_now,
        min_value: 2500,
        min_allowed_difference: 35,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id
      )
      category = Category.create!(name: 'Eletrônicos')
      product = Product.create!(
        name: 'Monitor LG',
        description: 'Monitor de 32 polegadas da marca LG...',
        weight: 1500,
        width: 100,
        height: 80,
        depth: 15,
        category:
      )
      lot.products << product
      lot.approved!

      travel_to 2.days.from_now do
        bid = Bid.new(user:, lot:, amount: 35)
        bid.valid?

        expect(bid.errors.full_messages).to include 'Um lance não pode ser dado em um lote que não está em andamento.'
      end
    end
  end
end
