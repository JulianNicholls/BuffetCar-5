class CommentsController < ApplicationController
  before_action :require_user

  def create
    @recipe = Recipe.find params[:recipe_id]
    @comment = @recipe.comments.build comment_params
    @comment.chef = current_chef

    if @comment.save
      if @recipe.comments.count == 1  # First one
        redirect_to @recipe
      else
        ActionCable.server.broadcast 'comments', render(partial: 'comments/comment', object: @comment)
      end
    else
      message = 'That comment could not be saved'
      if @comment.errors.any?
        message += ": #{@comment.errors.full_messages.first}"
      end

      flash[:danger] = message
      redirect_to :back
    end
  end

  private

  def comment_params
    params.require(:comment).permit :content
  end
end
