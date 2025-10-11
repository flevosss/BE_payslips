class PayslipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_hr

  def index
    @payslips = Payslip.includes(:employee, :generated_by).order(created_at: :desc)
    
    # Search functionality
    if params[:query].present?
      query = "%#{params[:query]}%"
      @payslips = @payslips.joins(employee: :user).where(
        "payslips.unique_number ILIKE ? OR employees.first_name ILIKE ? OR employees.last_name ILIKE ? OR employees.department ILIKE ? OR users.email ILIKE ?",
        query, query, query, query, query
      )
    end
  end

  def new
    @employees = Employee.includes(:user).order(:first_name, :last_name)
    @payslip = Payslip.new
  end

  def create
    @payslip = Payslip.new(payslip_params)
    @payslip.generated_by = current_user
    @payslip.generated_at = Time.current
    
    if @payslip.save
      redirect_to payslips_path, notice: "Payslip created successfully"
    else
      @employees = Employee.includes(:user).order(:first_name, :last_name)
      render :new, alert: "Failed to create payslip"
    end
  end

  private

  def payslip_params
    params.require(:payslip).permit(:employee_id, :date, :start_period, :end_period, :pay_date, :salary, :notes)
  end
end
  