require "pry"
class BooksController < ApplicationController
  def index
  	if params[:keyword]
  		if params[:search_condition] == "title"
  		  @books = RakutenWebService::Books::Book.search(title: params[:keyword])
  		elsif params[:search_condition] == "author"
  			@books = RakutenWebService::Books::Book.search(author: params[:keyword])
  		end

      #検索結果にgem kaminariにてpagenationを追加する。
      @books_full = [] #配列を用意
      page = 1

      while page <= 5 do #どんなに大量の検索結果でも10ページまでに制限
      last_items = @books.page(page)
        last_items.all do |item|
          @books_full.push(item)
        end
      end

      if @books_full.present?
        @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page]).per(30)
      end
  	end
  end

  def show
  	@book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
    @review = Review.new
    @reviews = Review.where(book_id: params[:id])
    @book_shelf = BookShelf.new
  end
end
