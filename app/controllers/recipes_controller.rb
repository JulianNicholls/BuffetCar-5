class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :like]
  before_action :require_user, except: [:index, :show, :like]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_user_like, only: :like

  def index
    @recipes = Recipe.includes(:ingredients, :recipe_ingredients, :chef, :comments).paginate page: params[:page], per_page: 5
  end

  def show
    @recipe   = Recipe.includes(:chef, :comments).find params[:id]
    @comments = @recipe.comments.paginate page: params[:page], per_page: 5
    @comment  = Comment.new
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

  def like
    like = Like.create upvote: params[:like], chef: current_chef, recipe: @recipe

    if like.valid?  # Chef hasn't voted on this one yet
      flash[:success] = "Your vote was registered"
    else
      flash[:danger] = "You can only vote once on a recipe"
    end

    redirect_to :back
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, ingredient_ids: [])
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

  def require_user_like
    unless logged_in?
      flash[:danger] = "You must be logged in to vote"
      redirect_to :back
    end
  end
end
