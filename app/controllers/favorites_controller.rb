class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
  	@review = Review.find(params[:review_user_id])
  	favorite = current_user.favorites.new(book_id: @review.id)
  	favorite.save
  end

  def destroy
  	@review = Review.find(params[:review_user_id])
  	favorite = current_user.favorites.new(book_id: @review.id)
    favorite.destroy
  end
end
