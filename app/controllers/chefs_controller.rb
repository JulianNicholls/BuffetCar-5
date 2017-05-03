class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_same_chef, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @chefs = Chef.includes(:recipes).paginate(page: params[:page], per_page: 5)
  end

  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new chef_params

    if @chef.save
      session[:chef_id]        = @chef.id
      cookies.signed[:chef_id] = @chef.id

      flash[:success] = "Welcome #{@chef.name}. You have signed up successfully"
      redirect_to @chef
    else
      render :new
    end
  end

  def show
    @chef_recipes = @chef.recipes.includes(:ingredients, :comments).paginate page: params[:page], per_page: 5
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
    if @chef.admin?
      flash[:danger] = 'Admin users cannot be deleted'
    else
      @chef.destroy
      flash[:danger] = 'The chef and all their recipes were deleted successfully'
    end

    redirect_to chefs_path
  end

  private

  def chef_params
    params.require(:chef).permit :name, :email,
                                 :password, :password_confirmation,
                                 :biography
  end

  def set_chef
    @chef = Chef.find params[:id]
  end

  def require_same_chef
    unless logged_in? && (current_chef.admin? || current_chef == @chef)
      flash[:danger] = 'You can only edit your own account'
      redirect_to chefs_path
    end
  end

  def require_admin
    unless logged_in? && current_chef.admin?
      flash[:danger] = 'Only administrators can delete chefs'
      redirect_to chefs_path
    end
  end
end
