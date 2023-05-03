require "rails_helper"

RSpec.describe Category, type: :model do
  describe "#valid?" do
    it "categoria deve ter um nome" do
      category = Category.new(name: "")

      category.valid?
      result = category.errors.full_messages

      expect(result).to include "Nome não pode ficar em branco"
    end
  end
end
