class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update]
  before_action :require_user, except: [:index, :show]

  def index
    @ingredients = Ingredient.paginate page: params[:page], per_page: 10
  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  private

  def ingredients_params
    params.require(:ingredient).permit :name
  end

  def set_ingredient
    @ingredient = Ingredient.find params[:id]
  end
end
