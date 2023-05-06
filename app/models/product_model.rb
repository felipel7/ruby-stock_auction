class ProductModel < ApplicationRecord
  belongs_to :category, optional: true

  before_validation :generate_code, on: :create
  validates :name, :description, :weight, :width, :height, :depth, presence: true
  validates :weight, :width, :height, :depth, numericality: { greater_than: 0 }

  def generate_code
    self.sku = SecureRandom.alphanumeric(10).upcase
  end

  def full_dimensions_desc
    "#{self.width}cm x #{self.height}cm x #{self.depth}cm"
  end
end
