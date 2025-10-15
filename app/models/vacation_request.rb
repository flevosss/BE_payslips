class VacationRequest < ApplicationRecord
  belongs_to :employee

  enum :status, { pending: 0, approved: 1, rejected: 2 }
  enum :leave_type, { vacation: 0, sick_leave: 1, personal_leave: 2, unpaid_leave: 3, other: 4 }

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true
  validates :leave_type, presence: true
  validate :end_date_after_start_date

  def days_count
    return 0 unless start_date && end_date
    (end_date - start_date).to_i + 1
  end

  def leave_type_display
    leave_type.humanize
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "Must be after the start date!")
    end
  end
end
