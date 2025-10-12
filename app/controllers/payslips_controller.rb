class PayslipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_hr

  def index
    @payslips = Payslip.includes(:employee, :generated_by).order(created_at: :desc)
    @payslips = search_payslips(@payslips) if params[:query].present?
  end

  def show
    @payslip = Payslip.includes(:employee, :generated_by).find(params[:id]) #find the payslip by id
    
    respond_to do |format|
      format.html { redirect_to payslips_path } #if the user tries to access the pdf directly, redirect to the payslips index page
      format.pdf do
        pdf = PayslipPdfGenerator.new(@payslip).generate
        send_data pdf, 
                  filename: generate_pdf_filename,
                  type: 'application/pdf',
                  disposition: 'attachment' #force the browser to download the pdf
      end
    end
  end

  def new
    @employees = Employee.includes(:user).order(:first_name, :last_name)
    @employees = search_employees(@employees) if params[:query].present?
    
    @payslip = Payslip.new
    # Pre-populate employee_id if passed in URL
    @payslip.employee_id = params[:employee_id] if params[:employee_id].present?
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

  def search_payslips(payslips) #this is for the payslips index page to search for payslips
    query = "%#{params[:query]}%"
    payslips.joins(employee: :user).where(
      "payslips.unique_number ILIKE ? OR employees.first_name ILIKE ? OR employees.last_name ILIKE ? OR employees.department ILIKE ? OR users.email ILIKE ?",
      query, query, query, query, query
    )
  end

  def search_employees(employees) #this is for the new payslip page to search for employees
    query = "%#{params[:query]}%"
    employees.joins(:user).where(
      "employees.first_name ILIKE ? OR employees.last_name ILIKE ? OR users.email ILIKE ?",
      query, query, query
    )
  end

  def payslip_params
    params.require(:payslip).permit(:employee_id, :date, :start_period, :end_period, :pay_date, :salary, :notes)
  end

  def generate_pdf_filename
    base_name = "payslip_#{@payslip.unique_number}_#{@payslip.employee.first_name}_#{@payslip.employee.last_name}"
    "#{base_name.parameterize(separator: '_')}.pdf"
  end
end
  