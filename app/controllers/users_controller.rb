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
    @user = current_user
    #is_vaildカラムをfalseへupdate
    if @user.update(is_valid: false)
       reset_session
       flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
       redirect_to root_path
    else
       render user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :family_name, :given_name, :family_name_kana, :given_name_kana, :gender, :age, :profession, :profile, :is_valid, :image)
  end

end
