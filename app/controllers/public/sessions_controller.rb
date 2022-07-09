# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :customer_state, only: [:create]

    def guest_sign_in
      customer = Customer.guest
      sign_in customer
      redirect_to customer_path(customer), notice: 'guestでログインしました'
    end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  #退会しているかどうかを判断するメソッド
  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email])
    return if !@customer
    if @customer.valid_password?(params[:customer][:password])
      ##customerの状態によって分岐します
      #available = 0 なのでイン出来ます
      if @customer.customer_style == "available"


        #quited = 1 で退会済みなのでインできません
      elsif @customer.customer_style == "quited"
        flash[:notice] = "新しく登録してください"
        redirect_to new_customer_registration_path

        #block = 2　なので、インできません
        #customerが問題を起こした時に使います
      else
        flash[:notice] = "blockされています"
        redirect_to root_path
      end
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
