class BooksController < ApplicationController
  include CommonActions
  before_action :book_serch, only: [:index]

  def index
  end

  def show
    @book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
    @review = Review.new
    @book_reviews = Review.where(book_id: params[:id]).page(params[:page]).reverse_order.per(10)
    @book_shelf = BookShelf.new
  end
end
