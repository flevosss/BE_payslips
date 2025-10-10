class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.includes(:employee).page(params[:page]).per(5) #no account here so no need to fetch that ;) Its so smart!!!
  end

  def show
    @user = User.includes(employee: :account_info).find(params[:id]) #basically we are calling the user model and then the employee model and then the account_info model to fetch everything from the user model and the employee model and the account_info model
  end

  private

  def check_admin
    redirect_to root_path, alert: "You are not authorized to access this page" unless current_user.admin?
  end
end
