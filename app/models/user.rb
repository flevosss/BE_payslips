class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :employee, dependent: :destroy
  has_many :payslips, foreign_key: 'generated_by_id', dependent: :destroy
  accepts_nested_attributes_for :employee

  enum :role, { employee: 0, admin: 1 }

  
  after_initialize :set_default_role, if: :new_record? #set the default role to employee if the user is new

  def set_default_role 
    self.role ||= :employee #set the default role to employee if the user is new
  end

  def hr?
    employee&.department == "Human Resources"
  end

  def can_view_employees?
    admin? || hr?
  end

  def can_delete_employees?
    admin?
  end
end
