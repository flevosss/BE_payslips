class MyProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    # Eager load employee and account_info associations
    @user = User.includes(employee: :account_info).find(current_user.id)
  end
end
