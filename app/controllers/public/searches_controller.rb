class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー名"
      @customers = Customer.looks(params[:search], params[:word]).page(params[:page]).per(10)
    else
      @exercises = Exercise.looks(params[:search], params[:word]).page(params[:page]).per(5)
    end
  end
end
