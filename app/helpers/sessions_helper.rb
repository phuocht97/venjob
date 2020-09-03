module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  def signed_in?
    current_user.present?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    return if cookies[:remember_token].blank?
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_out
    current_user.update_attribute(:remember_token, nil)
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    return session[:return_to] = request.referer if request.url.include?("favorite_job")
    session[:return_to] = request.url if request.get?
  end
end
