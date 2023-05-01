require "rails_helper"

RSpec.describe User, type: :model do
  describe "#role" do
    it "deve distinguir usuário comum de administrador pelo e-mail" do
      regular_user = User.create!(
        email: "felipe@gmail.com",
        cpf: "11111111111",
        password: "123123",
      )
      admin_user = User.create!(
        email: "felipe@leilaodogalpao.com.br",
        cpf: "11111111112",
        password: "123124",
      )

      expect(regular_user.role).to eq "user"
      expect(admin_user.role).to eq "admin"
    end
  end

  describe "#data" do
    it "email deve ser único" do
      first_user = User.create!(
        email: "felipe@gmail.com",
        cpf: "11111111111",
        password: "123123",
      )
      second_user = User.new(
        email: "felipe@gmail.com",
        cpf: "11111111112",
        password: "123124",
      )

      second_user.valid?
      error = second_user.errors.full_messages

      expect(error).to include "E-mail já está em uso"
    end

    it "cpf deve ser único" do
      first_user = User.create!(
        email: "felipe@gmail.com",
        cpf: "11111111111",
        password: "123123",
      )
      second_user = User.new(
        email: "felipe2@gmail.com",
        cpf: "11111111111",
        password: "123124",
      )

      second_user.valid?
      error = second_user.errors.full_messages

      expect(error).to include "Cpf já está em uso"
    end

    it "cpf deve ter 11 dígitos" do
      user = User.new(
        email: "felipe@gmail.com",
        cpf: "111",
        password: "123123",
      )

      user.valid?
      error = user.errors.full_messages

      expect(error).to include "Cpf não possui o tamanho esperado (11 caracteres)"
    end
  end
end
