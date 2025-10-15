class RequestController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.employee.present?
      @vacation_requests = current_user.employee.vacation_requests.order(created_at: :desc)
      @vacation_request = VacationRequest.new
    else
      @vacation_requests = []
      @vacation_request = VacationRequest.new
    end
  end

  def create_leave_request
    unless current_user.employee.present?
      redirect_to request_path, alert: "You must have an employee profile to request leave."
      return
    end

    @vacation_request = current_user.employee.vacation_requests.new(vacation_request_params)
    @vacation_request.status = :pending

    if @vacation_request.save
      redirect_to request_path, notice: "Leave request submitted successfully!"
    else
      @vacation_requests = current_user.employee.vacation_requests.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def vacation_request_params
    params.require(:vacation_request).permit(:start_date, :end_date, :reason, :leave_type)
  end
end
