class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update]
  before_action :require_admin_user, except: [:index, :show]

  def index
    @ingredients = Ingredient.includes(:recipes).paginate(page: params[:page], per_page: 10)
  end

  def show
    @ingredient_recipes = @ingredient.recipes.paginate page: params[:page], per_page: 5
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new ingredient_params
    if @ingredient.save
      flash[:success] = "#{@ingredient.name} was added successfully"
      redirect_to @ingredient
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @ingredient.update ingredient_params
      flash[:success] = "#{@ingredient.name} was updated successfully"
      redirect_to @ingredient
    else
      render :edit
    end

  end

  private

  def ingredient_params
    params.require(:ingredient).permit :name
  end

  def set_ingredient
    @ingredient = Ingredient.find params[:id]
  end

  def require_admin_user
    unless logged_in? && current_chef.admin?
      flash[:danger] = 'Only administrators can edit ingredients'
      redirect_to ingredients_path
    end
  end
end
