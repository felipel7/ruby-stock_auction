class Lot < ApplicationRecord
  belongs_to :user, foreign_key: :register_by_id
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
  has_many :products
  has_many :bids
  has_many :favorites
  has_many :lot_questions
  has_one_attached :photo

  enum status: { pending: 0, approved: 2, ended: 4, finished: 6, canceled: 8 }, _default: :pending
  scope :lots_in_future, -> { where(status: :approved).where('start_date > ?', Time.zone.now) }
  scope :lots_in_progress, -> { where(status: :approved).where('start_date <= ? AND end_date >= ?', Time.zone.now, Time.zone.now) }

  validates :batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, presence: true
  validates :batch_code, uniqueness: true
  validates :min_value, :min_allowed_difference, numericality: { greater_than: 0 }
  validates :start_date, comparison: {
                           greater_than: Time.zone.now,
                           message: I18n.t('lot.start_date'),
                         }, on: :create
  validates :end_date, comparison: {
                         greater_than: :start_date,
                         message: I18n.t('lot.end_date'),
                       }, on: :create

  validate :batch_code_format
  validate :validate_approval, if: -> { status_changed? && status == 'approved' }
  validate :validate_ended_lot, if: -> { status_changed? && (status == 'finished' || status == 'canceled') }

  def update_status
    if self.end_date < Time.zone.now
      self.status = :ended
      self.save
    end
  end

  private

  def batch_code_format
    if self.batch_code.length != 9
      return errors.add(:batch_code, I18n.t('lot.batch_code.length'))
    end

    if self.batch_code.count('A-Za-z') < 3
      errors.add(:batch_code, I18n.t('lot.batch_code.letters_length'))
    elsif self.batch_code.count('0-9') != 6
      errors.add(:batch_code, I18n.t('lot.batch_code.numbers_length'))
    end
  end

  def validate_approval
    admin_approval
    has_products
  end

  def admin_approval
    if self.register_by_id == self.approved_by_id
      errors.add(:base, I18n.t('lot.same_admin'))
    end
  end

  def has_products
    if self.products.empty?
      errors.add(:base, I18n.t('lot.empty_lot'))
    end
  end

  def validate_ended_lot
    if self.status == 'finished' && self.bids.empty?
      errors.add(:base, I18n.t('lot.bid_required'))
    elsif self.status == 'canceled' && !self.bids.empty?
      errors.add(:base, I18n.t('lot.cancel_with_active_bids'))
    end
  end
end
