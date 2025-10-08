class ProfilesController < ApplicationController
  skip_before_action :check_profile_complete #skip the check_profile_complete before_action because we want to allow the user to create a new employee without completing the profile first
  before_action :authenticate_user! #make sure the user is logged in

  def new #new is the action to create a new employee, it is called when the user visits the new.html.erb view
    @employee = Employee.new #passes an empty employee to the new.html.erb view so it can be used and filled in 
    @employee.build_account_info #creaes an empty account info for the employee to add later 
  end

  def create #create is the action to save the employee and account info to the database
    @employee = current_user.build_employee(employee_params) #builds the employee with the params from the new.html.erb view
    
    if @employee.save
      redirect_to root_path, notice: "Profile completed successfully!" #redirects to the root path with a notice that the profile was completed successfully
    else
      render :new, status: :unprocessable_entity #renders the new.html.erb view with a status of unprocessable entity if the employee is not saved
    end
  end

  private

  def employee_params #employee_params is the strong parameters for the employee
    params.require(:employee).permit(
      :first_name, :last_name, :date_of_birth, :address, :postal_code, :bsn,
      account_info_attributes: [:account_number, :account_name] #allows the account info to be saved to the database
    )
  end
end
