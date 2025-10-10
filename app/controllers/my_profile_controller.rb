class MyProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    # Eager load employee and account_info associations
    @user = User.includes(employee: :account_info).find(current_user.id)
  end

  def edit
    @user = current_user
    @user = User.includes(employee: :account_info).find(current_user.id)
  end

  def update
    @user = current_user
    
    if @user.employee.update(employee_params)
      redirect_to my_profile_path, notice: "Profile updated successfully"
    else
      redirect_to edit_my_profile_path, alert: "Failed to update profile"
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :date_of_birth, :address, :postal_code, :bsn, account_info_attributes: [:id, :account_name, :account_number])
  end
end
