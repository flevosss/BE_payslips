class PayslipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_hr

  def index
  end

  def new
  end

  def create
  end

  private

end
  