# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    message = 'ログインしました'
    flash[:success] = message
  end

  # DELETE /resource/sign_out
   def destroy
     super
    message = 'ログアウトしました'
    flash[:success] = message
   end

  # protected
  # ログイン後マイページへ遷移
  def after_sign_in_path_for(_resource)
    user_path(current_user.id)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
