# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_valid?, only: [:edit, :confirm, :hide]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    #退会済ユーザーページを閲覧しようとした時、マイページへ。
    @reviews = Review.where(user_id: params[:id])
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])

    @book_shelves = BookShelf.where(user_id: params[:id])
  end

  def edit
    #自分以外のユーザーが編集する事は不可
    if params[:id].to_i == current_user.id
      @user = current_user
    else
      redirect_to user_path(current_user.id)
    end
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
    params.require(:user).permit(:email, :password, :nickname, :gender, :age, :profession, :profile, :is_valid, :image)
  end

  def user_is_valid?
    #退会済ユーザーに関するビューを表示させない
    user = User.find(params[:id])
    if user.is_valid == false
      redirect_to user_path(current_user)
    end
  end
end
