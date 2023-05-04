class Lot < ApplicationRecord
  # TODO: belongs to admin lots
  # TODO: has many bids
  # TODO: has many lots products

  before_validation :generate_code
  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }
  validates :start_date, comparison: { greater_than: Time.now }
  validates :end_date, comparison: { greater_than: :start_date }

  private

  def generate_code
    letters = [*("A".."Z")].sample(3).join
    numbers = SecureRandom.random_number(999_999).to_s.rjust(6, "0")
    self.batch_code = letters + numbers
  end
end
