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
end