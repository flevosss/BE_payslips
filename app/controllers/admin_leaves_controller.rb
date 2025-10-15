class AdminLeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_only

  def index
    @vacation_requests = VacationRequest.includes(:employee)
                                       .order(created_at: :desc)
    
    # Search functionality
    if params[:query].present?
      query = "%#{params[:query]}%"
      @vacation_requests = @vacation_requests.joins(:employee).where(
        "employees.first_name ILIKE ? OR employees.last_name ILIKE ? OR employees.department ILIKE ? OR vacation_requests.reason ILIKE ? OR vacation_requests.leave_type::text ILIKE ?",
        query, query, query, query, query
      )
    end
    
    # Filter by status if requested
    if params[:status] == 'handled'
      @vacation_requests = @vacation_requests.where(status: [:approved, :rejected])
    elsif params[:status] == 'pending' || params[:status].blank?
      @vacation_requests = @vacation_requests.where(status: :pending)
    end
    
    # Pagination
    @vacation_requests = @vacation_requests.page(params[:page]).per(5)
  end

  def approve
    @vacation_request = VacationRequest.find(params[:id])
    if @vacation_request.update(status: :approved)
      redirect_back fallback_location: admin_leaves_path, notice: "Leave request approved successfully!"
    else
      redirect_back fallback_location: admin_leaves_path, alert: "Failed to approve leave request."
    end
  end

  def reject
    @vacation_request = VacationRequest.find(params[:id])
    if @vacation_request.update(status: :rejected)
      redirect_back fallback_location: admin_leaves_path, notice: "Leave request rejected."
    else
      redirect_back fallback_location: admin_leaves_path, alert: "Failed to reject leave request."
    end
  end

  private

  def check_admin_only
    unless current_user.admin?
      redirect_to dashboard_path, alert: "You don't have permission to access this page. Admin access only."
    end
  end
end

