class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.includes(:employee).page(params[:page]).per(5) #no account here so no need to fetch that ;) Its so smart!!!
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

  def check_admin
    redirect_to root_path, alert: "You are not authorized to access this page" unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:role, employee_attributes: [:id, :department])
  end
end
