# frozen_string_literal: true
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_valid?, only: [:show]

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id]).page(params[:page]).per(10)
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])
  end

  def create
  	@review = Review.new(reviews_params)
  	@review.user_id = current_user.id
  	if @review.save
  		redirect_to book_path(@review.book_id)
  	else
      #books/showへrenderで返すのに必要/valitationErrorで必要
      @book_details = RakutenWebService::Books::Book.search(isbn: @review.book_id.to_i)
      @reviews = Review.where(book_id:  @review.book_id.to_i).page(params[:page]).per(10)
      @book_shelf = BookShelf.new
      render "books/show"
  	end
  end

  def destroy
    @review = Review.find_by(params[:id])
    @review.destroy
    redirect_to book_path(@review.book_id)
  end

  private

  def reviews_params
		params.require(:review).permit(:user_id, :book_id,:title,:text)
	end

  def user_is_valid?
    #退会済ユーザーに関するビューを表示させない
    user = User.find(params[:id])
    if user.is_valid == false
      redirect_to user_path(current_user)
    end
  end
end
