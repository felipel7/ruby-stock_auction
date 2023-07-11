class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :lot, optional: true
  has_one_attached :photo

  before_validation :generate_code, on: :create
  validates :name, :description, :weight, :width, :height, :depth, presence: true
  validates :weight, :width, :height, :depth, numericality: { greater_than: 0 }
  validate :products_uniqueness_in_lot

  def full_dimensions_desc
    "#{width}cm x #{height}cm x #{depth}cm"
  end

  private

  def generate_code
    self.sku = SecureRandom.alphanumeric(10).upcase
  end

  def products_uniqueness_in_lot
    lot = Lot.joins(:products).where(products: { id: }).first

    return unless lot && lot.id != self.lot.id

    errors.add(:base, I18n.t('product.product_not_available'))
  end
end
