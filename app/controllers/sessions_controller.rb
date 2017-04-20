class SessionsController < ApplicationController
  def new

  end

  def create
    chef = Chef.find_by email: session_params[:email].downcase
    if chef && chef.authenticate(session_params[:password])
      session[:chef_id] = chef.id
      flash[:success] = "You have logged in successfully"
      redirect_to chef
    else
      flash.now[:danger] = "Your email address or password were not recognised"
      render :new
    end
  end

  def destroy
    session[:chef_id] = nil
    flash[:success] = "You have logged out successfully"
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit :email, :password
  end
end
