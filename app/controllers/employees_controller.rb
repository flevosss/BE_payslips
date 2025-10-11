class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_hr

  def index
    @users = User.includes(:employee)
    
    # Search functionality
    if params[:query].present?
      query = params[:query].downcase
      filtered_users = @users.select do |user|
        user.email.downcase.include?(query) ||
        user.employee&.first_name&.downcase&.include?(query) ||
        user.employee&.last_name&.downcase&.include?(query) ||
        user.employee&.department&.downcase&.include?(query)
      end
      # Convert back to User relation for pagination
      @users = User.where(id: filtered_users.map(&:id)).includes(:employee)
    end
    
    @users = @users.page(params[:page]).per(5)
  end

  def show
    @user = User.includes(employee: :account_info).find(params[:id]) #basically we are calling the user model and then the employee model and then the account_info model to fetch everything from the user model and the employee model and the account_info model
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    # Prevent demoting yourself
    if @user.id == current_user.id && @user.admin? && params[:user][:role] == 'employee'
      redirect_to edit_employee_path(@user), alert: "You cannot demote yourself from admin"
      return
    end
    
    if @user.update(user_params)
      redirect_to employee_path(@user), notice: "Employee updated successfully"
    else
      redirect_to edit_employee_path(@user), alert: "Failed to update employee"
    end
  end

  def destroy
    # Only admins can delete employees
    unless current_user.can_delete_employees?
      redirect_to employees_path, alert: "You don't have permission to delete employees"
      return
    end

    @user = User.find(params[:id])
    
    # Prevent deleting yourself
    if @user.id == current_user.id
      redirect_to employee_path(@user), alert: "You cannot delete your own account"
      return
    end
    
    if @user.destroy
      redirect_to employees_path, notice: "Employee deleted successfully"
    else
      redirect_to employee_path(@user), alert: "Failed to delete employee"
    end
  end

  private


  def user_params
    params.require(:user).permit(:role, employee_attributes: [:id, :department])
  end
end
