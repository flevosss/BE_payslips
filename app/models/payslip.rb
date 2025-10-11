class Payslip < ApplicationRecord
  belongs_to :employee
  belongs_to :generated_by, class_name: 'User'

  validates :unique_number, presence: true, uniqueness: true
  validates :date, presence: true
  validates :start_period, presence: true
  validates :end_period, presence: true
  validates :pay_date, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates :generated_by, presence: true

  before_validation :generate_unique_number, on: :create

  private

  def generate_unique_number # in the payslip controller when you click save, it will call this.
    return if unique_number.present?
    
    # Generate format: PAY-YYYY-MM-RANDOM
    current_date = Date.current
    year = current_date.year
    month = current_date.month.to_s.rjust(2, '0')
    random_number = rand(1000..9999)
    
    self.unique_number = "PAY-#{year}-#{month}-#{random_number}"
  end
end
