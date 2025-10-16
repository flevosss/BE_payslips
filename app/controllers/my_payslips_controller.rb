class MyPayslipsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.employee.present?
      @payslips = current_user.employee.payslips.includes(:generated_by).order(created_at: :desc)
      @payslips = search_payslips(@payslips) if params[:query].present?
    else
      @payslips = []
    end
  end

  def show
    # Only allow access to their own payslips
    @payslip = current_user.employee.payslips.find(params[:id])
    
    respond_to do |format|
      format.html { redirect_to my_payslips_path }
      format.pdf do
        pdf = PayslipPdfGenerator.new(@payslip).generate
        send_data pdf, 
                  filename: "payslip_#{@payslip.unique_number}_#{current_user.employee.first_name}_#{current_user.employee.last_name}.pdf",
                  type: 'application/pdf',
                  disposition: 'attachment'
      end
    end
  end

  private

  def search_payslips(payslips)
    query = "%#{params[:query]}%"
    payslips.where(
      "payslips.unique_number ILIKE ? OR payslips.notes ILIKE ? OR CAST(payslips.salary AS TEXT) ILIKE ?",
      query, query, query
    )
  end
end
