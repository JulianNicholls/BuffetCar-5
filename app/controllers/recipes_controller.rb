class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]

  def index
    @recipes = Recipe.all
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new recipe_params

    @recipe.chef = Chef.first   # TODO

    if @recipe.save
      flash[:success] = "The recipe was added successfully."
      redirect_to @recipe
    else
      render :new
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit :name, :description
  end

  def set_recipe
    @recipe = Recipe.find params[:id]
  end
end
