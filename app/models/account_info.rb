class AccountInfo < ApplicationRecord
  belongs_to :employee

  validates :account_number, presence: true
  validates :account_name, presence: true

  validates :account_number, uniqueness: true
  validates :account_number, length: { in: 15..34 }

end
