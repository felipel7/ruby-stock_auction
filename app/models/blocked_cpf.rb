class BlockedCpf < ApplicationRecord
  validates :cpf, presence: true
end
