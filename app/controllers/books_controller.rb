
class BooksController < ApplicationController
  def index
  	if params[:keyword] == "" #キーワード空欄の場合
      flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
    else
      @books_full = [] #配列を用意
  		if params[:search_condition] == "title"
  		  books = RakutenWebService::Books::Book.search(title: params[:keyword])
        #検索結果にgem kaminariにてpagenationを追加する。
        books.all.each do |book| #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)
        end
  		elsif params[:search_condition] == "author"
  			books = RakutenWebService::Books::Book.search(author: params[:keyword])
        #検索結果にgem kaminariにてpagenationを追加する。
        books.all.each do |book| #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)
        end
      else
        flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
  		end

      if @books_full.present?
        @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
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
