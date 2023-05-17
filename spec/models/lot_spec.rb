require "rails_helper"

RSpec.describe Lot, type: :model do
  describe "#valid?" do
    it "não é possível criar um novo lote com os dados incorretos" do
      lot = Lot.new(
        batch_code: "EOR661430",
        start_date: nil,
        end_date: nil,
        min_value: 0,
        min_allowed_difference: -2,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).to include "Data de início não pode ficar em branco"
      expect(error).to include "Data de encerramento não pode ficar em branco"
      expect(error).to include "Valor mínimo inicial deve ser maior que 0"
      expect(error).to include "Valor mínimo do lance deve ser maior que 0"
    end

    it "o lote é criado com sucesso quando preenchido corretamente" do
      admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")

      lot = Lot.new(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 1.hour.from_now,
        min_value: 150,
        min_allowed_difference: 10,
        register_by_id: admin.id,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).to eq []
      expect(error).not_to include "Data de início não pode ficar em branco"
      expect(error).not_to include "Valor mínimo deve ser maior que 0"
    end

    it "data de inicio não pode ser no passado" do
      date_past = 1.minute.ago
      date_now = Time.now

      lot = Lot.new(
        batch_code: "EOR661430",
        start_date: date_past,
        end_date: 1.hour.from_now,
        min_value: 150,
        min_allowed_difference: 10,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).not_to eq []
      expect(error).to include "Data de início deve ser posterior à hora atual"
    end

    it "data de encerramento não pode ser anterior a data de início" do
      admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      start_date_time = 1.hour.from_now
      lot = Lot.new(
        batch_code: "EOR661430",
        start_date: start_date_time,
        end_date: 1.minute.from_now,
        min_value: 150,
        min_allowed_difference: 10,
        register_by_id: admin.id,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).not_to eq []
      expect(error).to include "Data de encerramento deve ser posterior à data de início"
    end

    it "o código gerado manualmente deve ter 3 letras e 6 números" do
      admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      lot = Lot.new(
        batch_code: "EO6614R30",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: admin.id,
      )

      lot.valid?

      expect(lot.batch_code.scan(/[A-Z]/).count).to eq(3)
      expect(lot.batch_code.scan(/[0-9]/).count).to eq(6)
    end

    it "o código do lote deve ser único" do
      admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      first_lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: admin.id,
      )
      second_lot = Lot.new(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: admin.id,
      )

      second_lot.valid?
      error = second_lot.errors.full_messages

      expect(error).to include "Código do Lote já está em uso"
    end

    it "o produto não pode estar em dois lotes ao mesmo tempo" do
      admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")

      first_lot = Lot.create!(
        batch_code: "HZK119066",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: admin.id,
      )
      second_lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: admin.id,
      )
      category = Category.create!(name: "Eletrônicos")
      product = ProductModel.create!(
        name: "Smartphone Samsung",
        description: "Smartphone Samsung Galaxy S21 com tela de 6.2 polegadas...",
        weight: 200,
        width: 7.1,
        height: 15.1,
        depth: 8,
        category: category,
      )

      second_lot.product_models << product
      first_lot.product_models << product

      expect(second_lot.product_models.present?).to be true
      expect(first_lot.product_models.present?).to be false
      expect(second_lot.product_models).to include(product)
      expect(first_lot.product_models).not_to include(product)
    end
  end
end
