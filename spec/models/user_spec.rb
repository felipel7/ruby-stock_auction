require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#role' do
    it 'deve distinguir usuário comum de administrador pelo e-mail' do
      regular_user = User.create!(
        email: 'felipe@gmail.com',
        cpf: '96585753070',
        password: '123123'
      )
      admin_user = User.create!(
        email: 'felipe@leilaodogalpao.com.br',
        cpf: '91720461040',
        password: '123124'
      )

      expect(regular_user.role).to eq 'user'
      expect(admin_user.role).to eq 'admin'
    end
  end

  describe '#valid?' do
    it 'E-mail deve ser único' do
      User.create!(
        email: 'felipe@gmail.com',
        cpf: '61902427076',
        password: '123123'
      )
      user = User.new(
        email: 'felipe@gmail.com',
        cpf: '08736710075',
        password: '123124'
      )

      user.valid?
      errors = user.errors.full_messages

      expect(errors).to include 'E-mail já está em uso'
    end

    context 'CPF' do
      it 'deve ser único' do
        User.create!(
          email: 'felipe@gmail.com',
          cpf: '81258837030',
          password: '123123'
        )
        user = User.new(
          email: 'felipe2@gmail.com',
          cpf: '81258837030',
          password: '123124'
        )

        user.valid?
        errors = user.errors.full_messages

        expect(errors).to include 'CPF já está em uso'
      end

      it 'deve ter 11 dígitos' do
        user = User.new(
          email: 'felipe@gmail.com',
          cpf: '111',
          password: '123123'
        )

        user.valid?
        errors = user.errors.full_messages

        expect(errors).to include 'CPF não possui o tamanho esperado (11 caracteres)'
      end

      it 'deve ser válido com dados corretos' do
        user = User.new(
          email: 'felipe@gmail.com',
          cpf: '04536086048',
          password: '123123'
        )

        result = user.valid?

        expect(result).to be true
      end

      it 'deve ser inválido com dados incorretos' do
        user = User.new(
          email: 'felipe@gmail.com',
          cpf: '12345678901',
          password: '123123'
        )

        result = user.valid?
        errors = user.errors.full_messages

        expect(errors).to include 'CPF inválido'
        expect(result).to be false
      end
    end
  end
end
