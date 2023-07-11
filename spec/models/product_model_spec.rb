require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it 'deve falhar se os campos obrigatórios não forem passados' do
      product = Product.new(
        name: '',
        description: '',
        sku: '',
        width: '',
        height: '',
        weight: '',
        depth: '',
        category: nil
      )

      product.valid?
      error = product.errors.full_messages

      expect(error).to include 'Nome não pode ficar em branco'
      expect(error).to include 'Descrição não pode ficar em branco'
      expect(error).to include 'Peso não pode ficar em branco'
      expect(error).to include 'Altura não pode ficar em branco'
      expect(error).to include 'Largura não pode ficar em branco'
      expect(error).to include 'Profundidade não pode ficar em branco'
      expect(error).not_to include 'Categoria é obrigatório(a)'
    end

    it 'deve passar caso os campos sejam passados corretamente' do
      category = Category.create!(name: 'Eletrônicos')

      product = Product.new(
        name: 'Monitor LG',
        description: 'Monitor de 24 polegadas da marca LG...',
        weight: 15,
        width: 100,
        height: 80,
        depth: 10,
        category:
      )

      product.valid?
      error = product.errors.full_messages

      expect(error).to eq []
      expect(error).not_to include 'Nome não pode ficar em branco'
      expect(error).not_to include 'Profundidade não pode ficar em branco'
    end

    it 'deve gerar um código automático alfanumérico com 10 caracteres' do
      category = Category.create!(name: 'Eletrônicos')

      product = Product.new(
        name: 'Monitor LG',
        description: 'Monitor de 24 polegadas da marca LG...',
        weight: 15,
        width: 100,
        height: 80,
        depth: 10,
        category:
      )

      product.save!
      result = product.sku

      expect(result).not_to be_empty
      expect(result.length).to eq 10
    end
  end
end
