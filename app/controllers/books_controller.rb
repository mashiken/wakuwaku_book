class BooksController < ApplicationController

  def index
  	if params[:keyword]
  		@books = RakutenWebService::Books::Book.search(title: params[:keyword])
  	end
  end

  def show
  	@book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
  end
end
