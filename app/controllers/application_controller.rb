class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	add_flash_types :success, :danger, :info

  before_action :ensure_login
  helper_method :logged_in?, :current_user, :is_admin?, :ensure_admin, :ensure_not_guest # these will be available in views erb

  protected
  	def ensure_login
  		redirect_to login_path unless (session[:user_id] || session[:guest])
  	end

  	def logged_in?
      # currently, this will return false for guests
  		session[:user_id]
  	end

  	def current_user
      # behaviour not well defined for guest user.
  		@current_user ||= User.find(session[:user_id])
  	end

    def is_admin?
      return (logged_in? and current_user.user_class == "admin")
    end

    def ensure_admin
      redirect_to root_path unless is_admin?
    end

    def ensure_not_guest
      redirect_to login_path unless logged_in?
    end
end
