class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :amount, presence: true
  validate :check_min_bid_allowed_difference
  validate :lot_available_for_bidding

  private

  def check_min_bid_allowed_difference
    allowed_diff = self.lot&.min_allowed_difference
    if allowed_diff.to_i > self.amount.to_i
      self.errors.add(:amount, "deve ser maior que o mínimo permitido para cada lance.")
    end
  end

  def lot_available_for_bidding
    unless Lot.lots_in_progress.include?(self.lot)
      self.errors.add(:base, "Um lance não pode ser dado em um lote que não está em andamento.")
    end
  end
end
