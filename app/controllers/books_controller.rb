class BooksController < ApplicationController

  def index
  	if params[:keyword]
  		if params[:search_condition] == "title"
  		  @books = RakutenWebService::Books::Book.search(title: params[:keyword])
  		elsif params[:search_condition] == "author"
  			@books = RakutenWebService::Books::Book.search(author: params[:keyword])
  		end
  	end
  end

  def show
  	@book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
    @review = Review.new
    @reviews = Review.where(book_id: params[:id])
  end
end
