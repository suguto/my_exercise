class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :secure_customer, only: [:edit]

  def show
    @customer = Customer.find(params[:id])
    @exercises = @customer.exercises.order(id: "DESC").page(params[:page]).per(5)
    exercise_ids = @customer.favorites.pluck(:exercise_id)
    @favorites = Exercise.where(id: exercise_ids).order(id: "DESC").page(params[:page]).per(10)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(current_customer)
    else
      render 'edit'
    end
  end

  def withdraw
    customer = Customer.find(params[:id])
    customer.update(customer_style: "quited")
    reset_session
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :introduction, :profile_image)
  end

  def secure_customer
    @customer = Customer.find(params[:id])
    #ゲストログインでマイページ編集ページに飛べないようにする
    if @customer.name == "guest"
      redirect_to customer_path(current_customer), notice: "guestのプロフィール編集ページへ遷移できません"
    #他のcustomerの編集ページへ遷移できないようにする
    elsif
      @customer != current_customer
      redirect_to customer_path(current_customer)
    end
  end
end
