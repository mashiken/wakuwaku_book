# frozen_string_literal: true
require 'pry'
class ReviewsController < ApplicationController
  def index
    @reviews = Review.where(user_id: params[:id])
    book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
  end

  def create
    binding.pry
  	@review = Review.new(reviews_params)
  	@review.user_id = current_user.id
  	if @review.save
  		redirect_to book_path(@review.book_id)
  	else
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
end
