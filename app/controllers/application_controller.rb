class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end

  def render_error_404
    respond_to do |format|
      format.html { render template: 'errors/error_404', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_error_500
    respond_to do |format|
      format.html { render template: 'errors/error_500', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end
end
