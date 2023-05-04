class ProductModel < ApplicationRecord
  belongs_to :category, optional: true

  before_validation :generate_code, on: :create
  validates :name, :description, :weight, :width, :height, :depth, presence: true

  def generate_code
    self.sku = SecureRandom.alphanumeric(10).upcase
  end
end
