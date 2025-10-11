class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  before_action :check_profile_complete, if: :user_signed_in?

  private

  def check_profile_complete
    # Skip check if on profile completion pages or Devise pages
    return if controller_name == 'profiles' || devise_controller?
    
    if current_user.employee.nil?
      redirect_to new_profile_path, alert: "Please complete your profile to continue"
    end
  end

  def after_sign_out_path_for(resource_or_scope) #this is what devise does by default, so we need to override it
    new_user_session_path #this is the path that devise will redirect to after signing out
  end

  def check_admin_or_hr
    unless current_user.can_view_employees?
      redirect_to dashboard_path, alert: "You don't have permission to access this page"
    end
  end
end