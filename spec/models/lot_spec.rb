require "rails_helper"

RSpec.describe Lot, type: :model do
  describe "#valid?" do
    it "deve falhar se os campos forem passados incorretamente" do
      lot = Lot.new(
        start_date: nil,
        end_date: nil,
        min_value: 0,
        min_allowed_difference: -2,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).to include "Data de início não pode ficar em branco"
      expect(error).to include "Data de encerramento não pode ficar em branco"
      expect(error).to include "Valor mínimo deve ser maior que 0"
      expect(error).to include "Valor mínimo da diferença deve ser maior que 0"
    end

    it "deve passar caso os campos sejam passados corretamente" do
      lot = Lot.new(
        start_date: 1.minute.from_now,
        end_date: 1.hour.from_now,
        min_value: 150,
        min_allowed_difference: 10,
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
      start_date_time = 1.hour.from_now
      lot = Lot.new(
        start_date: start_date_time,
        end_date: 1.minute.from_now,
        min_value: 150,
        min_allowed_difference: 10,
      )

      lot.valid?
      error = lot.errors.full_messages

      expect(error).not_to eq []
      expect(error).to include "Data de encerramento deve ser posterior à data de início"
    end

    it "deve gerar um código automático de 3 letras e 6 números" do
      lot = Lot.new(
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
      )

      lot.valid?

      expect(lot.batch_code[0..2]).to match(/[A-Z]{3}/)
      expect(lot.batch_code[3..-1]).to match(/[0-9]{6}/)
    end
  end
end
