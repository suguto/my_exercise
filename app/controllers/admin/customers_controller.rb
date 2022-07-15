class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.all.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_back(fallback_location: root_path)
  end

  def searches
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー名"
      @customers = Customer.looks(params[:search], params[:word]).page(params[:page]).per(10)
    else
      @exercises = Exercise.looks(params[:search], params[:word]).page(params[:page]).per(5)
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:customer_style)
  end

end
