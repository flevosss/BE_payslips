class Employee < ApplicationRecord
    belongs_to :user

    has_one :account_info, dependent: :destroy #has one account info, if the employee is deleted, the account info is also deleted
    has_many :payslips, dependent: :destroy

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :date_of_birth, presence: true
    validates :address, presence: true
    validates :postal_code, presence: true
    validates :bsn, presence: true

    validates :bsn, uniqueness: true
    validates :bsn, length: { is: 9 }

    accepts_nested_attributes_for :account_info #for the second table account_info

    def full_name_with_email
        if first_name.present? && last_name.present?
            "#{first_name} #{last_name} (#{user.email})"
        else
            user.email
        end
    end
end
