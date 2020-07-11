
class BooksController < ApplicationController

  def index
  	if params[:keyword] == ""
      flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
    else
      if params[:search_condition] == "title"

        books = RakutenWebService::Books::Book.search(title: params[:keyword]) #titleで検索
        @books_full = []
        #配列を用意(kaminari/pagenation)

        books.all.each do |book|   #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)   #books.allを切り分けたbookを1つずつ配列へ挿入
        end

        if @books_full.present?    #結果として配列にデータがあるか？あればpagination設定 無しならErrorMessage
          @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
        else
          flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、検索ワードの入力をお願いします。'
        end

      elsif params[:search_condition] == "author"
        books = RakutenWebService::Books::Book.search(author: params[:keyword]) #authorで検索
        @books_full = []
        #配列を用意(kaminari/pagenation)

        books.all.each do |book|   #books.allで検索結果の全ての商品単位を取得
          @books_full.push(book)   #books.allを切り分けたbookを1つずつ配列へ挿入
        end

        if @books_full.present?    #結果として配列にデータがあるか？あればpagination設定 無しならErrorMessage
          @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
        else
          flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、検索ワードの入力をお願いします。'
        end
      end
    end
  end

  def show
  	@book_details = RakutenWebService::Books::Book.search(isbn: params[:id])
    @review = Review.new
    @reviews = Review.where(book_id: params[:id]).page(params[:page]).reverse_order.per(10)
    @book_shelf = BookShelf.new
  end
end
