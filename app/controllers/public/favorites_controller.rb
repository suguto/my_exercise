class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!

  def favorites_all
    exercises = Exercise.find(params[:exercise_id])
    favorites_ids = exercises.favorites.pluck(:customer_id)
    @customers = Customer.where(id: favorites_ids).order(id: "DESC").page(params[:page]).per(5)
  end

  def ranking
    favorites= Exercise.find(Favorite.group(:exercise_id).order('count(exercise_id) desc').pluck(:exercise_id))
    @favorites_ranking = Kaminari.paginate_array(favorites).page(params[:page]).per(5)
  end

  def create
    @exercise = Exercise.find(params[:exercise_id])
    favorite = current_customer.favorites.new(exercise_id: @exercise.id)
    favorite.save
  end

  def destroy
    @exercise = Exercise.find(params[:exercise_id])
    favorite = current_customer.favorites.find_by(exercise_id: @exercise.id)
    favorite.destroy
  end
end
