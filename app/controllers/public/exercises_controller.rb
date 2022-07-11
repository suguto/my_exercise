class Public::ExercisesController < ApplicationController
  before_action :authenticate_customer!
  before_action :secure_exercise, only: [:edit]

  def new
    @exercise = current_customer.exercises.new
  end

  def index
    @exercises = Exercise.all.order(id: "DESC").page(params[:page]).per(10)
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def edit
    @exercise = Exercise.find(params[:id])
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
