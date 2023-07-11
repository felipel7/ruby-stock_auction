class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :amount, presence: true
  validate :check_min_bid_allowed_difference
  validate :lot_available_for_bidding
  validate :check_last_bid_user, on: :create

  private

  def check_min_bid_allowed_difference
    allowed_diff = lot&.min_allowed_difference
    return unless allowed_diff.to_i > amount.to_i

    errors.add(:base, I18n.t('bid.minimum_bid_diff'))
  end

  def lot_available_for_bidding
    return if Lot.lots_in_progress.include?(lot)

    errors.add(:base, I18n.t('bid.lot_not_in_progress'))
  end

  def check_last_bid_user
    last_bid = lot.bids.last if lot&.bids
    return unless last_bid&.user == user

    errors.add(:base, I18n.t('bid.user_already_last_bid'))
  end
end
