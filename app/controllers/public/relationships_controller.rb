class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!

  def followings
    @index = true
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followings.order(id: "DESC").page(params[:page]).per(10)
  end

  def followers
    @index = true
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followers.order(id: "DESC").page(params[:page]).per(10)
  end

  def create
    @customer = Customer.find(params[:customer_id])
    current_customer.follow!(@customer)
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow!(@customer)
  end

end
