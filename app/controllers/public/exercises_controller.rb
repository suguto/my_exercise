class Public::ExercisesController < ApplicationController
  before_action :authenticate_customer!
  before_action :secure_exercise, only: [:edit]

  def new
    @exercise = current_customer.exercises.new
  end

  def index
    customer_ids = Customer.all.pluck(:id)
    @exercises = Exercise.where(customer_id: customer_ids).order(id: "DESC").page(params[:page]).per(10)
    #user_ids = current_user.followings.pluck(:id)
    #@articles = Article.where(user_id:user_ids)
  end

  def show
    @exercise = Exercise.find(params[:id])
    @comment_new = Comment.new
  end

  def edit
    @exercise = Exercise.find(params[:id])
  end

  def timeline
    customer_ids = current_customer.followings.pluck(:id)
    @exercises = Exercise.where(customer_id: customer_ids).order(id: "DESC").page(params[:page]).per(5)
  end

  def create
    @exercise = current_customer.exercises.new(exercise_params)
    if @exercise.save
      redirect_to exercises_path
    else
      flash[:notice] = "1文字以上、写真は4枚以下にしてください"
      render 'new'
    end
  end

  def update
    @exercise = Exercise.find(params[:id])
    if @exercise.update(exercise_params)
      redirect_to exercises_path
    else
      flash[:notice] = "1文字以上、写真は4枚以下にしてください"
      redirect_to edit_exercise_path(@exercise)
    end
  end

  def destroy
    exercise = Exercise.find(params[:id])
    exercise.destroy
    if URI.parse(request.referer).path == exercise_path(params[:id])
      redirect_to exercises_path
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:body, body_images: [])
  end

  #自分の投稿内容以外に飛べないようにするメソッド
  def secure_exercise
    @exercise = Exercise.find(params[:id])
      if @exercise.customer_id != current_customer.id
        redirect_to exercises_path
      end
  end
end
