class Public::CommentsController < ApplicationController

  def create
    @exercise = Exercise.find(params[:exercise_id])
    @comment = current_customer.comments.new(comment_params)
    @comment.exercise_id = @exercise.id
    if @comment.save
      render 'exercise_show_comments'
    else
      flash[:notice] = "入力してください"
      @comment_new = Comment.new
      render 'public/exercises/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @exercise = Exercise.find(params[:exercise_id])
    render 'exercise_show_comments'
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_to)
  end

end
