class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update, :destroy]

  def index
    @chefs = Chef.paginate page: params[:page], per_page: 5
  end

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
    @chef_recipes = @chef.recipes.paginate page: params[:page], per_page: 5
  end

  def edit

  end

  def update
    if @chef.update chef_params
      flash[:success] = "Your profile was updated successfully"
      redirect_to @chef
    else
      render :edit
    end
  end

  def destroy
    @chef.destroy
    flash[:danger] = 'The chef and all their recipes were deleted successfully'
    redirect_to chefs_path
  end

  private

  def chef_params
    params.require(:chef).permit :name, :email, :password, :password_confirmation
  end

  def set_chef
    @chef = Chef.find params[:id]
  end
end
