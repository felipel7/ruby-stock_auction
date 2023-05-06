class Lot < ApplicationRecord
  belongs_to :user, foreign_key: :register_by_id
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true

  enum status: { pending: 0, approved: 5, sold: 10, inactive: 15 }, _default: :pending

  before_validation :generate_code, on: :create
  validates :batch_code, uniqueness: true
  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }
  validates :start_date, comparison: { greater_than: Time.now,
                                       message: "deve ser posterior à hora atual" }
  validates :end_date, comparison: { greater_than: :start_date,
                                     message: "deve ser posterior à data de início" }
  validate :validate_different_users

  private

  def generate_code
    letters = [*("A".."Z")].sample(3).join
    numbers = SecureRandom.random_number(999_999).to_s.rjust(6, "0")
    self.batch_code = letters + numbers
  end

  def validate_different_users
    if self.register_by_id == self.approved_by_id
      self.errors.add(:aprovado_por_id, "deve ser diferente do usuário que cadastrou o lote")
    end
  end
end
