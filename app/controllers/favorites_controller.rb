class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    review = Review.find(params[:review_id])
    favorite = current_user.favorites.new(review_id: review.id)
    favorite.save
    # 非同期通信に必要な変数(reviews/showからの変更点)
    @user = User.find(review.user_id)
    @reviews = Review.where(user_id: review.user_id).page(params[:page]).reverse_order.per(10)
    @recommended = RecommendedBook.where(user_id: review.user_id)
    @recommended_user = RecommendedBook.where(recommended_user_id: review.user_id)
  end

  def destroy
    review = Review.find(params[:review_id])
    favorite = current_user.favorites.find_by(review_id: @review.id)
    favorite.destroy
    # 非同期通信に必要な変数(reviews/showからの変更点)
    @user = User.find(review.user_id)
    @reviews = Review.where(user_id: review.user_id).page(params[:page]).reverse_order.per(10)
    @recommended = RecommendedBook.where(user_id: review.user_id)
    @recommended_user = RecommendedBook.where(recommended_user_id: review.user_id)
  end
end
