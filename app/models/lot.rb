class Lot < ApplicationRecord
  belongs_to :user, foreign_key: :register_by_id
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true
  has_many :products
  has_many :bids
  has_many :favorites
  has_one_attached :photo

  enum status: { pending: 0, approved: 2, ended: 4, finished: 6, canceled: 8 }, _default: :pending
  scope :lots_in_progress, -> { where(status: :approved).where("start_date <= ? AND end_date >= ?", Time.zone.now, Time.zone.now) }
  scope :lots_in_future, -> { where(status: :approved).where("start_date > ?", Time.zone.now) }

  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :batch_code, uniqueness: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }
  validates :start_date, comparison: { greater_than: Time.zone.now,
                                       message: "deve ser posterior à hora atual" }, on: :create
  validates :end_date, comparison: { greater_than: :start_date,
                                     message: "deve ser posterior à data de início" }, on: :create
  validate :batch_code_format
  validate :validate_approval, if: -> { status_changed? && status == "approved" }
  validate :validate_ended_lot, if: -> { status_changed? && (status == "finished" || status == "canceled") }

  def update_status
    if self.end_date < Time.zone.now
      self.status = :ended
      self.save
    end
  end

  private

  def batch_code_format
    if self.batch_code.length != 9
      return self.errors.add(:batch_code, "deve ter 9 caracteres")
    end

    if self.batch_code.count("A-Za-z") < 3
      self.errors.add(:batch_code, "deve ter pelo menos 3 letras")
    elsif self.batch_code.count("0-9") != 6
      self.errors.add(:batch_code, "deve ter pelo menos 6 números")
    end
  end

  def validate_approval
    admin_approval
    has_products
  end

  def admin_approval
    if self.register_by_id == self.approved_by_id
      self.errors.add(:approved_by, "deve ser diferente do admin que cadastrou o lote")
    end
  end

  def has_products
    if self.products.empty?
      self.errors.add(:products, "deve ser incluído para que um lote possa ser aprovado")
    end
  end

  def validate_ended_lot
    if self.status == "finished" && self.bids.empty?
      self.errors.add(:base, "Não é possível validar o resultado de um lote sem lances.")
    elsif self.status == "canceled" && !self.bids.empty?
      self.errors.add(:base, "O cancelamento só é permitido quando não existem lances associados.")
    end
  end
end
