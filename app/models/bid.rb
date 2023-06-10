class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :amount, presence: true
  validate :check_min_bid_allowed_difference
  validate :lot_available_for_bidding
  validate :check_last_bid_user, on: :create

  private

  def check_min_bid_allowed_difference
    allowed_diff = self.lot&.min_allowed_difference
    if allowed_diff.to_i > self.amount.to_i
      errors.add(:base, I18n.t("bid.minimum_bid_diff"))
    end
  end

  def lot_available_for_bidding
    unless Lot.lots_in_progress.include?(self.lot)
      errors.add(:base, I18n.t("bid.lot_not_in_progress"))
    end
  end

  def check_last_bid_user
    last_bid = self.lot.bids.last if self.lot&.bids
    if last_bid && last_bid.user == self.user
      errors.add(:base, I18n.t("bid.user_already_last_bid"))
    end
  end
end
