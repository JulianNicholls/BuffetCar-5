class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_chef, :logged_in?

  def current_chef
    chef_id = session[:chef_id]
    @current_chef ||= Chef.find chef_id if chef_id
  end

  def logged_in?
    !!current_chef
  end

  def require_user
    if !logged_in?
      flash[:danger] = 'You must be logged in to do that'
      redirect_to root_path
    end
  end
end
