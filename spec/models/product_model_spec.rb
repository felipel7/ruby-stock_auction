require "rails_helper"

RSpec.describe ProductModel, type: :model do
  describe "#valid?" do
    it "deve falhar se os campos obrigatórios não forem passados" do
      product = ProductModel.new(
        name: "",
        description: "",
        sku: "",
        # picture: "",
        width: "",
        height: "",
        weight: "",
        depth: "",
        category: nil,
      )

      product.valid?
      error = product.errors.full_messages

      expect(error).to include "Nome não pode ficar em branco"
      expect(error).to include "Descrição não pode ficar em branco"
      expect(error).to include "Peso não pode ficar em branco"
      expect(error).to include "Altura não pode ficar em branco"
      expect(error).to include "Largura não pode ficar em branco"
      expect(error).to include "Profundidade não pode ficar em branco"
      expect(error).not_to include "Categoria é obrigatório(a)"
    end

    it "deve passar caso os campos obrigatórios sejam passados" do
      category = Category.create!(name: "Eletrônicos")

      product_model = ProductModel.new(
        name: "Monitor LG",
        description: "Monitor de 24 polegadas da marca LG...",
        weight: 15,
        width: 100,
        # picture: "",
        height: 80,
        depth: 10,
        category: category,
      )

      product_model.valid?
      error = product_model.errors.full_messages

      expect(error).to eq []
      expect(error).not_to include "Nome não pode ficar em branco"
      expect(error).not_to include "Profundidade não pode ficar em branco"
    end

    it "deve gerar um código automático alfanumérico com 10 caracteres" do
      category = Category.create!(name: "Eletrônicos")

      product_model = ProductModel.new(
        name: "Monitor LG",
        description: "Monitor de 24 polegadas da marca LG...",
        weight: 15,
        width: 100,
        # picture: "",
        height: 80,
        depth: 10,
        category: category,
      )

      product_model.save!
      result = product_model.sku

      expect(result).not_to be_empty
      expect(result.length).to eq 10
    end
  end
end
