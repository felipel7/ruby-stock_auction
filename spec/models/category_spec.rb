require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    it 'categoria deve ter um nome' do
      category = Category.new(name: '')

      category.valid?
      errors = category.errors.full_messages

      expect(errors).to include 'Nome não pode ficar em branco'
    end

    it 'categoria não pode ser duplicada' do
      Category.create!(name: 'Esportes')
      category = Category.new(name: 'Esportes')

      category.valid?
      errors = category.errors.full_messages

      expect(errors).to include 'Nome já está em uso'
    end
  end
end
