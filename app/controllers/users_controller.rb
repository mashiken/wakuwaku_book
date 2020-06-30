# frozen_string_literal: true

class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find_by(params[:id])
    @book_shelves = BookShelf.where(user_id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_customer
    if @user.update(user_params)
      redirect_to users_path(current_user.id)
    else
      render "edit"
    end
  end

  def confirm
  end

  def hide
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :family_name, :given_name, :family_name_kana, :given_name_kana, :gender, :age, :profession, :profile, :is_valid)
  end

end
