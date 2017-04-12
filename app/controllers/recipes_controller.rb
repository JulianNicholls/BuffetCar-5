class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.paginate page: params[:page], per_page: 5
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new recipe_params
    @recipe.chef = current_chef

    if @recipe.save
      flash[:success] = "The recipe was added successfully"
      redirect_to @recipe
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @recipe.update recipe_params
      flash[:success] = "The recipe was updated successfully"
      redirect_to @recipe
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    flash[:success] = "The recipe was deleted successfully"
    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit :name, :description
  end

  def set_recipe
    @recipe = Recipe.find params[:id]
  end

  def require_same_user
    unless current_chef.admin? || current_chef == @recipe.chef
      flash[:danger] = 'You can only edit your own recipes'
      redirect_to recipes_path
    end
  end
end
