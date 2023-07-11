class Lot < ApplicationRecord
  belongs_to :user, foreign_key: :register_by_id, inverse_of: false
  belongs_to :approved_by, class_name: 'User', optional: true
  has_many :products, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :photo

  enum status: { pending: 0, approved: 2, ended: 4, finished: 6, canceled: 8 }, _default: :pending
  scope :lots_in_future, -> { where(status: :approved).where('start_date > ?', Time.zone.now) }
  scope :lots_in_progress, lambda {
                             where(status: :approved).where('start_date <= ? AND end_date >= ?',
                                                            Time.zone.now, Time.zone.now)
                           }

  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :batch_code, uniqueness: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }
  validates :start_date, comparison: {
    greater_than: Time.zone.now,
    message: I18n.t('lot.start_date')
  }, on: :create
  validates :end_date, comparison: {
    greater_than: :start_date,
    message: I18n.t('lot.end_date')
  }, on: :create

  validate :batch_code_format
  validate :validate_approval, if: -> { status_changed? && status == 'approved' }
  validate :validate_ended_lot, if: -> { status_changed? && (status == 'finished' || status == 'canceled') }

  def update_status
    return unless end_date < Time.zone.now

    self.status = :ended
    save
  end

  private

  def batch_code_format
    return errors.add(:batch_code, I18n.t('lot.batch_code.length')) if batch_code.length != 9

    if batch_code.count('A-Za-z') < 3
      errors.add(:batch_code, I18n.t('lot.batch_code.letters_length'))
    elsif batch_code.count('0-9') != 6
      errors.add(:batch_code, I18n.t('lot.batch_code.numbers_length'))
    end
  end

  def validate_approval
    admin_approval
    products?
  end

  def admin_approval
    return unless register_by_id == approved_by_id

    errors.add(:base, I18n.t('lot.same_admin'))
  end

  def products?
    return false unless products.empty?

    errors.add(:base, I18n.t('lot.empty_lot'))
  end

  def validate_ended_lot
    if status == 'finished' && bids.empty?
      errors.add(:base, I18n.t('lot.bid_required'))
    elsif status == 'canceled' && !bids.empty?
      errors.add(:base, I18n.t('lot.cancel_with_active_bids'))
    end
  end
end
