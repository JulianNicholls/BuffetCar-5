class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update]
  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new chef_params

    if @chef.save
      flash[:success] = "Welcome #{@chef.name}. You have signed up successfully"
      redirect_to @chef
    else
      render :new
    end
  end

  def show

  end

  private

  def chef_params
    params.require(:chef).permit :name, :email, :password, :password_confirmation
  end

  def set_chef
    @chef = Chef.find params[:id]
  end
end
