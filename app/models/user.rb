class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 5 }

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
end
