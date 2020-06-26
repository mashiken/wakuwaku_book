class BooksController < ApplicationController

  def index
  	if params[:keyword]
  		@books = RakutenWebService::Books::Book.search(title: params[:keyword])
  	end
  end

  def show
  end
end
