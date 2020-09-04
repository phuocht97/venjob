class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end
end
