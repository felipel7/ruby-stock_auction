class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 5 }

  before_validation :valid_cpf
  after_initialize :set_default_role, :if => :new_record?
  before_save :check_email_domain

  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }

  private

  def set_default_role
    self.role ||= :user
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
    primo = 11

    # calc first digit
    cpf_numbers.each_char do |n|
      total += n.to_i * factor
      factor -= 1
    end
    rest_second_to_last = total % primo
    rest_second_to_last = primo - rest_second_to_last
    first_check_digit = rest_second_to_last >= 10 ? 0 : rest_second_to_last

    # calc second digit
    factor = 11
    total = 0
    (cpf_numbers + first_check_digit.to_s).each_char do |n|
      total += n.to_i * factor
      factor -= 1
    end
    rest_to_last = total % primo
    rest_to_last = primo - rest_to_last
    second_check_digit = rest_to_last >= 10 ? 0 : rest_to_last

    result = first_check_digit.to_s + second_check_digit.to_s != cpf_code

    if result
      self.errors.add(:cpf, "inválido")
    end
  end
end
