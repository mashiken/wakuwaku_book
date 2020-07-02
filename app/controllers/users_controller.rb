# frozen_string_literal: true

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id])
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])

    @book_shelves = BookShelf.where(user_id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user.id)
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
