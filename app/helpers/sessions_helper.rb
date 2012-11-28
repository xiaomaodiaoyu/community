module SessionsHelper
  def log_in(user)
  # cookies[:remember_token] = { value:   user.remember_token,
  #                              expires: 20.years.from_now.utc }
  	cookies.permanent[:remember_token] = user.remember_token
   	self.current_user = user
  end

  # set
  def current_user=(user)
 	  @current_user = user
  end
  
  # get
  def current_user
   	@current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
  	!current_user.nil?
  end

  def log_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def loggedin_user
    unless logged_in?
      store_location  
      redirect_to login_path, notice: "Please log in."
    end
  end

end