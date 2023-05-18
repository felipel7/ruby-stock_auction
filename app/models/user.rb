class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lots
  has_many :bids
  has_many :favorites

  enum role: { user: 0, admin: 5 }
  after_initialize :set_default_role, :if => :new_record?
  before_validation :valid_cpf
  before_validation :check_blocked_cpf, on: :create
  before_save :check_email_domain

  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }

  def is_admin?
    self.role == "admin"
  end

  def name
    self.email.split("@")[0].capitalize
  end

  def active_for_authentication?
    super && !blocked_cpf?
  end

  def blocked_cpf?
    BlockedCpf.exists?(cpf: self.cpf)
  end

  private

  def check_blocked_cpf
    if blocked_cpf?
      self.errors.add(:cpf, "está bloqueado, entre em contato com o suporte.")
    end
  end

  def set_default_role
    self.role = :user
  end

  def check_email_domain
    if self.email.end_with?("@leilaodogalpao.com.br")
      self.role = :admin
    end
  end

  def valid_cpf
    if self.cpf.nil?
      return self.errors.add(:cpf, " inválido")
    end

    cpf_numbers = self.cpf[0..8]
    cpf_code = self.cpf[9..-1]
    total = 0
    factor = 10
    prime = 11

    cpf_numbers.each_char do |n|
      total += n.to_i * factor
      factor -= 1
    end
    rest_second_to_last_number = prime - (total % prime)
    first_digit = rest_second_to_last_number >= 10 ? 0 : rest_second_to_last_number

    factor = 11
    total = 0
    (cpf_numbers + first_digit.to_s).each_char do |n|
      total += n.to_i * factor
      factor -= 1
    end
    rest_last_number = prime - (total % prime)
    second_digit = rest_last_number >= 10 ? 0 : rest_last_number

    result = first_digit.to_s + second_digit.to_s != cpf_code

    if result
      self.errors.add(:cpf, "inválido")
    end
  end
end
