# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_valid?, only: [:show]

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id]).page(params[:page]).reverse_order.per(10)
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])
  end

  def create
    @review = Review.new(reviews_params)
    @review.user_id = current_user.id

    # books/showへ非同期で必要
    @book_details = RakutenWebService::Books::Book.search(isbn: @review.book_id.to_i)
    @book_shelf = BookShelf.new

    if @review.save
      @reviews = Review.where(book_id: @review.book_id.to_i).page(params[:page]).reverse_order.per(10)
      @review = Review.new
      # books/create.js.erbへ非同期処理
      respond_to do |format|
        format.js { render file: '/books/create.js.erb' }
      end
    else
      # books/showへ非同期で必要
      @reviews = Review.where(book_id: @review.book_id.to_i).page(params[:page]).reverse_order.per(10)
      # books/create.js.erbへ非同期処理
      respond_to do |format|
        format.js { render file: '/books/create.js.erb' }
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    @book_details = RakutenWebService::Books::Book.search(isbn: @review.book_id.to_i)
    @reviews = Review.where(book_id: @review.book_id.to_i).page(params[:page]).per(10)
    @book_shelf = BookShelf.new

    respond_to do |format|
      format.js { render file: '/books/destroy.js.erb' }
    end
  end

  private

  def reviews_params
    params.require(:review).permit(:user_id, :book_id, :title, :text)
  end

  def user_is_valid?
    # 退会済ユーザーに関するビューを表示させない
    user = User.find(params[:id])
    redirect_to user_path(current_user) if user.is_valid == false
  end
end
