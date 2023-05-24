class Category < ApplicationRecord
  has_many :product_models

  validates :name, presence: true, uniqueness: true
end
