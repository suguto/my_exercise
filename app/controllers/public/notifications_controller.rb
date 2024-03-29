class Public::NotificationsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @notifications = current_customer.passive_notifications.page(params[:page]).per(5)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notifications = current_customer.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
