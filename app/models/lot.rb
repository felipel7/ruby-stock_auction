class Lot < ApplicationRecord
  # TODO: belongs to admin lots
  # TODO: has many bids
  # TODO: has many lots products

  enum status: { pending: 0, approved: 5, sold: 10 }, _default: :pending

  before_validation :generate_code, on: :create
  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }

  validates :start_date, comparison: { greater_than: Time.now,
                                       message: "deve ser posterior à hora atual" }

  validates :end_date, comparison: { greater_than: :start_date,
                                     message: "deve ser posterior à data de início" }

  private

  def generate_code
    letters = [*("A".."Z")].sample(3).join
    numbers = SecureRandom.random_number(999_999).to_s.rjust(6, "0")
    self.batch_code = letters + numbers
  end
end
